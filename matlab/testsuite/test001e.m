
clear all

magnet_fixed.dim = [0.03 0.04 0.05];
magnet_float.dim = [0.055 0.045 0.035];

magnet_fixed.type = 'cuboid';
magnet_float.type = 'cuboid';

magnet_fixed.magn = 1;
magnet_float.magn = 1;

[x,y,z]=sph2cart(30*pi/180, 50*pi/180, 1);
magnet_fixed.magdir = [x y z];

[x,y,z]=sph2cart(60*pi/180, 45*pi/180, 1);
magnet_float.magdir = [x y z];

displ = [0.1 0.09 0.11];

f_all = magnetforces(magnet_fixed,magnet_float,displ);

assert( all( round(f_all*1e6) == [-1391969;    -1140254;    -1042102]) , ...
  'Forces components appear incorrect.')



