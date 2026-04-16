# OpenFOAM-3D-LPCS-nozzle

OpenFOAM case files for a 3D LPCS nozzle simulation (Concordia University capstone project).

## Repository contents

- `0/`: Initial and boundary conditions (`p`, `T`, `U`, `k`, `omega`, `nut`, `alphat`)
- `constant/`: Material, turbulence, and mesh data
  - `thermophysicalProperties`: Perfect gas with Sutherland viscosity
  - `turbulenceProperties`: RAS `kOmegaSST`
  - `polyMesh/`: Existing mesh and boundary definitions
- `system/`: Solver controls and numerical settings (`controlDict`, `fvSchemes`, `fvSolution`, decomposition and patch dictionaries)
- `mesh3d.geo`: Gmsh geometry for the 3D nozzle/ambient domain
- `job.sh`: Example HPC run script (Narval)

## Solver setup

- Main application in `system/controlDict`: `rhoCentralFoam`
- HPC script currently launches: `foamRun -solver shockFluid -parallel`
- Parallel decomposition in `system/decomposeParDict`: `numberOfSubdomains 256`

## Boundary naming

Main patches used across fields:

- `Input`
- `Output`
- `NozzleWall`
- `AmbientSide`
- `defaultFaces`

## Requirements

- OpenFOAM v13 (as used in `job.sh`)
- MPI runtime (for parallel runs)
- Optional: Gmsh (to regenerate/update mesh from `mesh3d.geo`)

## Running the case

### 1) Prepare working directory

From the case root:

```bash
cd /path/to/openFOAM-3D-LPCS-nozzle
```

### 2) Clean previous decomposition/time directories

```bash
rm -rf processor* processors*
rm -rf $(find . -maxdepth 1 -name "[0-9]*" -not -name "0")
```

### 3) Decompose and run in parallel

```bash
decomposePar -force > log.decompose 2>&1
mpirun -np 256 foamRun -solver shockFluid -parallel -case . > log.foam 2>&1
```

> Adjust `-np` and `numberOfSubdomains` together when changing core count.

### 4) Post-processing

Use ParaView with OpenFOAM reader on the case directory, or inspect logs:

- `log.decompose`
- `log.foam`

## Notes

- The provided `job.sh` is cluster-specific and contains a user-specific path; update it for your environment.
- If you switch to direct `rhoCentralFoam`, ensure `system/controlDict` and your launch command are consistent.
