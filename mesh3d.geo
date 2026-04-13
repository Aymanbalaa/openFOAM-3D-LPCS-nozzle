

// these identify how many cells should be in each section of the nozzle like 50 in the convergent 150 in the divergent 130 in the plume region 30 radially and 15 radially in the ambient cells
nz_conv  = 50;
nz_div   = 120;
nz_amb   = 130;
nr       = 30;
nr_far   = 15;

// this identifies where the key points that need more attention to be studied like at the inlet at the throat and at the outlet and the corresponding walls
Point(1)  = {0,     0,   0,   1};  
Point(2)  = {4.8,   0,   0,   1};  
Point(3)  = {0,     0,   7.5, 1};  
Point(4)  = {1.5,   0,   7.5, 1};  
Point(5)  = {0,     0, 107.5, 1};  
Point(6)  = {2.075, 0, 107.5, 1};  
Point(7)  = {0,     0, 367.5, 1};  
Point(8)  = {2.075, 0, 367.5, 1}; 
Point(9)  = {10,    0, 107.5, 1}; 
Point(10) = {10,    0, 367.5, 1};  

// this does the curvature at the thoat
Point(11) = {3.90,  0,  2.0, 1};
Point(12) = {2.80,  0,  4.5, 1};
Point(13) = {2.00,  0,  6.2, 1};
// the same here but for the wall
Point(15) = {1.511, 0,   9.5, 1};
Point(16) = {1.570, 0,  17.5, 1};
Point(17) = {1.720, 0,  32.5, 1};
Point(18) = {1.900, 0,  52.5, 1};
Point(19) = {2.040, 0,  77.5, 1};

//here are the lines that connect everything together
Line(1)  = {1, 2};
Spline(2) = {2, 11, 12, 13, 4};
Line(3)  = {1, 3};
Line(4)  = {3, 4};
Spline(5) = {4, 15, 16, 17, 18, 19, 6};
Line(6)  = {3, 5};
Line(7)  = {5, 6};
Line(8)  = {5, 7};
Line(9)  = {7, 8};
Line(10) = {6, 8};
Line(11) = {6, 9};
Line(12) = {9, 10};
Line(13) = {8, 10};

// here each state of the nozzle is defined as a closed loop of lines just to construct them seperately
Line Loop(1) = {1, 2, -4, -3};
Plane Surface(1) = {1};
Line Loop(2) = {4, 5, -7, -6};
Plane Surface(2) = {2};
Line Loop(3) = {7, 10, -9, -8};
Plane Surface(3) = {3};
Line Loop(4) = {11, 12, -13, -10};
Plane Surface(4) = {4};

// all of these below tells gmesh how to construct a structured mesh following all the lines that are mentionned earlier for every section of the nozzle and each line has a specific number of nodes that matches the resolution and this is the first half and then revolves it to the second half
Transfinite Line{1} = nr+1;
Transfinite Line{4} = nr+1;
Transfinite Line{7} = nr+1;
Transfinite Line{9} = nr+1;
Transfinite Line{11} = nr_far+1;
Transfinite Line{13} = nr_far+1;
Transfinite Line{3} = nz_conv+1;
Transfinite Line{2} = nz_conv+1;
Transfinite Line{6} = nz_div+1;
Transfinite Line{5} = nz_div+1;
Transfinite Line{8} = nz_amb+1;
Transfinite Line{10} = nz_amb+1;
Transfinite Line{12} = nz_amb+1;

Transfinite Surface{1} = {1,2,4,3};
Transfinite Surface{2} = {3,4,6,5};
Transfinite Surface{3} = {5,6,8,7};
Transfinite Surface{4} = {6,9,10,8};
Recombine Surface{1,2,3,4};

angle = Pi/2;
out1[] = Extrude {{0,0,1},{0,0,0}, angle} { Surface{1,2,3,4}; Layers{20}; Recombine; };
out2[] = Extrude {{0,0,1},{0,0,0}, angle} { Surface{out1[0],out1[5],out1[10],out1[15]}; Layers{20}; Recombine; };
out3[] = Extrude {{0,0,1},{0,0,0}, angle} { Surface{out2[0],out2[5],out2[10],out2[15]}; Layers{20}; Recombine; };
out4[] = Extrude {{0,0,1},{0,0,0}, angle} { Surface{out3[0],out3[5],out3[10],out3[15]}; Layers{20}; Recombine; };

Physical Volume("internal") = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};

Physical Surface("Input")      = {1, out1[1], out2[1], out3[1], out4[1]};
Physical Surface("Output")     = {out1[14],out2[14],out3[14],out4[14], out1[19],out2[19],out3[19],out4[19]};
Physical Surface("NozzleWall") = {out1[2],out2[2],out3[2],out4[2],out1[6],out2[6],out3[6],out4[6]};
Physical Surface("AmbientSide")= {out1[17],out2[17],out3[17],out4[17], out1[18],out2[18],out3[18],out4[18]};
