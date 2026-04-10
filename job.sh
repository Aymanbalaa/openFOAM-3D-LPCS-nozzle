#!/bin/bash
#SBATCH --job-name=delaval_yes
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --account=def-tembelym
#SBATCH --time=10:00:00
#SBATCH --output=log.slurm

cd /home/naim123/yes
module load openfoam/13
rm -rf processor* processors*
rm -rf $(find . -maxdepth 1 -name "[0-9]*" -not -name "0")
sed -i 's/numberOfSubdomains.*/numberOfSubdomains  256;/' system/decomposeParDict
decomposePar -force > log.decompose 2>&1
mpirun -np 256 foamRun -solver shockFluid -parallel -case . > log.foam 2>&1
