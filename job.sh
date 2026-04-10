// this file makes the simulation run on narval HPC using 4 nodes with 64 cpus each for 10 hours and puts in a queue of jobs

cd /home/naim123/yes
module load openfoam/13
rm -rf processor* processors*
rm -rf $(find . -maxdepth 1 -name "[0-9]*" -not -name "0")
sed -i 's/numberOfSubdomains.*/numberOfSubdomains  256;/' system/decomposeParDict
decomposePar -force > log.decompose 2>&1
mpirun -np 256 foamRun -solver shockFluid -parallel -case . > log.foam 2>&1
