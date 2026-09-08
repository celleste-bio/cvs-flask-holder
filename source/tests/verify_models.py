#!/usr/bin/env python3
import os
import sys
import struct
import math

def read_stl_bounds(file_path):
    """
    Reads an STL file (ASCII or Binary) and returns its bounding box:
    (min_x, max_x, min_y, max_y, min_z, max_z)
    """
    min_x, max_x = float('inf'), float('-inf')
    min_y, max_y = float('inf'), float('-inf')
    min_z, max_z = float('inf'), float('-inf')
    
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"STL file not found: {file_path}")

    with open(file_path, 'rb') as f:
        header = f.read(5)
        
    is_ascii = (header == b'solid')
    
    if is_ascii:
        with open(file_path, 'r', errors='ignore') as f:
            for line in f:
                parts = line.strip().split()
                if parts and parts[0] == 'vertex':
                    try:
                        x, y, z = float(parts[1]), float(parts[2]), float(parts[3])
                        min_x = min(min_x, x)
                        max_x = max(max_x, x)
                        min_y = min(min_y, y)
                        max_y = max(max_y, y)
                        min_z = min(min_z, z)
                        max_z = max(max_z, z)
                    except (ValueError, IndexError):
                        pass
    else:
        with open(file_path, 'rb') as f:
            f.read(80)  # skip header
            try:
                num_triangles = struct.unpack('<I', f.read(4))[0]
            except struct.error:
                raise ValueError(f"Corrupt binary STL header/size in {file_path}")
                
            for _ in range(num_triangles):
                f.read(12)  # skip normal vector
                vdata = f.read(36)
                if len(vdata) < 36:
                    break
                v = struct.unpack('<9f', vdata)
                for i in range(3):
                    x, y, z = v[i*3], v[i*3+1], v[i*3+2]
                    min_x = min(min_x, x)
                    max_x = max(max_x, x)
                    min_y = min(min_y, y)
                    max_y = max(max_y, y)
                    min_z = min(min_z, z)
                    max_z = max(max_z, z)
                f.read(2)  # skip attribute byte count
                
    return min_x, max_x, min_y, max_y, min_z, max_z

def run_tests(models_dir):
    """
    Discovers all models in the models_dir and validates:
      1. Flask STL: Ground alignment (Z_min=0) and X/Y symmetry around origin.
      2. Holder STL (Flat Print Layout): Ground alignment (Z_min=0) and positive quadrant placement (X_min=0, Y_min=0).
      3. Holder Assembled STL: Ground alignment (Z_min=0) and positive quadrant placement (X_min=0, Y_min=0).
      4. Holder With Flask STL: Ground alignment (Z_min=0) and positive quadrant placement in X (X_min=0).
    """
    if not os.path.isdir(models_dir):
        print(f"Error: models directory '{models_dir}' does not exist.")
        return False

    success = True
    epsilon = 1e-4
    
    # Get all subdirectory names representing sizes
    sizes = sorted([d for d in os.listdir(models_dir) if os.path.isdir(os.path.join(models_dir, d))])
    
    print(f"Found {len(sizes)} size configurations to verify: {', '.join(sizes)}\n")
    print("-" * 80)
    print(f"{'Size Config':<30} | {'Model File':<25} | {'Status':<10}")
    print("-" * 80)
    
    for size in sizes:
        size_path = os.path.join(models_dir, size)
        
        # 1. Verify flask.stl
        flask_stl = os.path.join(size_path, "flask.stl")
        if os.path.exists(flask_stl):
            try:
                min_x, max_x, min_y, max_y, min_z, max_z = read_stl_bounds(flask_stl)
                # Assertions
                assert abs(min_z) < epsilon, f"flask.stl Z_min is {min_z:.4f}, expected 0.0"
                assert abs(min_x + max_x) < epsilon, f"flask.stl X is asymmetric: [{min_x:.4f}, {max_x:.4f}]"
                assert abs(min_y + max_y) < epsilon, f"flask.stl Y is asymmetric: [{min_y:.4f}, {max_y:.4f}]"
                print(f"{size:<30} | {'flask.stl':<25} | PASSED")
            except AssertionError as e:
                print(f"{size:<30} | {'flask.stl':<25} | FAILED ({e})")
                success = False
            except Exception as e:
                print(f"{size:<30} | {'flask.stl':<25} | ERROR ({e})")
                success = False
        else:
            print(f"{size:<30} | {'flask.stl':<25} | MISSING")
            
        # 2. Verify holder.stl (flat print layout)
        holder_stl = os.path.join(size_path, "holder.stl")
        if os.path.exists(holder_stl):
            try:
                min_x, max_x, min_y, max_y, min_z, max_z = read_stl_bounds(holder_stl)
                # Assertions
                assert abs(min_z) < epsilon, f"holder.stl Z_min is {min_z:.4f}, expected 0.0"
                assert abs(min_x) < epsilon, f"holder.stl X_min is {min_x:.4f}, expected 0.0"
                assert abs(min_y) < epsilon, f"holder.stl Y_min is {min_y:.4f}, expected 0.0"
                print(f"{size:<30} | {'holder.stl (print)':<25} | PASSED")
            except AssertionError as e:
                print(f"{size:<30} | {'holder.stl (print)':<25} | FAILED ({e})")
                success = False
            except Exception as e:
                print(f"{size:<30} | {'holder.stl (print)':<25} | ERROR ({e})")
                success = False
        else:
            print(f"{size:<30} | {'holder.stl (print)':<25} | MISSING")
            
        # 3. Verify holder_assembled.stl
        assembled_stl = os.path.join(size_path, "holder_assembled.stl")
        if os.path.exists(assembled_stl):
            try:
                min_x, max_x, min_y, max_y, min_z, max_z = read_stl_bounds(assembled_stl)
                # Assertions
                assert abs(min_z) < epsilon, f"holder_assembled.stl Z_min is {min_z:.4f}, expected 0.0"
                assert abs(min_x) < epsilon, f"holder_assembled.stl X_min is {min_x:.4f}, expected 0.0"
                assert abs(min_y) < epsilon, f"holder_assembled.stl Y_min is {min_y:.4f}, expected 0.0"
                print(f"{size:<30} | {'holder_assembled.stl':<25} | PASSED")
            except AssertionError as e:
                print(f"{size:<30} | {'holder_assembled.stl':<25} | FAILED ({e})")
                success = False
            except Exception as e:
                print(f"{size:<30} | {'holder_assembled.stl':<25} | ERROR ({e})")
                success = False
        else:
            print(f"{size:<30} | {'holder_assembled.stl':<25} | MISSING")
            
        # 4. Verify holder_with_flask.stl
        with_flask_stl = os.path.join(size_path, "holder_with_flask.stl")
        if os.path.exists(with_flask_stl):
            try:
                min_x, max_x, min_y, max_y, min_z, max_z = read_stl_bounds(with_flask_stl)
                # Assertions
                assert abs(min_z) < epsilon, f"holder_with_flask.stl Z_min is {min_z:.4f}, expected 0.0"
                assert abs(min_x) < epsilon, f"holder_with_flask.stl X_min is {min_x:.4f}, expected 0.0"
                print(f"{size:<30} | {'holder_with_flask.stl':<25} | PASSED")
            except AssertionError as e:
                print(f"{size:<30} | {'holder_with_flask.stl':<25} | FAILED ({e})")
                success = False
            except Exception as e:
                print(f"{size:<30} | {'holder_with_flask.stl':<25} | ERROR ({e})")
                success = False
        else:
            print(f"{size:<30} | {'holder_with_flask.stl':<25} | MISSING")
            
        print("-" * 80)
        
    return success

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_dir = os.path.dirname(os.path.dirname(script_dir))
    models_directory = os.path.join(repo_dir, "models")
    
    if len(sys.argv) > 1:
        models_directory = sys.argv[1]
        
    print(f"Starting model verification in: {models_directory}\n")
    all_passed = run_tests(models_directory)
    
    if all_passed:
        print("\nAll model validations PASSED successfully!")
        sys.exit(0)
    else:
        print("\nSome model validations FAILED. Please check the log above.")
        sys.exit(1)
