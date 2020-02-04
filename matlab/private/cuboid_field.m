function [magBx,magBy,magBz,ptx,pty,ptz] = cuboid_field(mag,ptx,pty,ptz)

J = mag.magn*mag.magdir;

% Set up variables
vertx = mag.vertices(:,1);
verty = mag.vertices(:,2);
vertz = mag.vertices(:,3);

% Mesh everything for vectorisation
[ptx2,vertx2] = matrgrid(ptx,vertx);
[pty2,verty2] = matrgrid(pty,verty);
[ptz2,vertz2] = matrgrid(ptz,vertz);

[Bxx,Bxy,Bxz] = cuboid_field_x(ptx2,pty2,ptz2,vertx2,verty2,vertz2,J);
[Byx,Byy,Byz] = cuboid_field_y(ptx2,pty2,ptz2,vertx2,verty2,vertz2,J);
[Bzx,Bzy,Bzz] = cuboid_field_z(ptx2,pty2,ptz2,vertx2,verty2,vertz2,J);

magBx = Bxx+Byx+Bzx;
magBy = Bxy+Byy+Bzy;
magBz = Bxz+Byz+Bzz;

end

function [pointsM,vertsM] = matrgrid(points,verts)

NV = numel(verts);

pointsM = repmat(points,[1,1,NV]);
vertsM = nan(size(points,1),size(points,2),NV);
for ii = 1:NV
  vertsM(:,:,ii) = repmat(verts(ii),size(points));
end

end

function [Bx,By,Bz] = cuboid_field_x(x,y,z,xprime,yprime,zprime,J)

Jx = J(1);

DD = Jx/(4*pi)*(-1).^(0:7)';
D = nan(size(x,1),size(x,2),8);
for ii = 1:8
  D(:,:,ii) = repmat(DD(ii),size(x,1),size(x,2));
end

% Solve field
zeta = sqrt((x-xprime).^2+(y-yprime).^2+(z-zprime).^2);
Bxc = D.*atan((y-yprime).*(z-zprime)./((x-xprime).*zeta));
Byc = D.*log(-z+zprime+zeta);
Bzc = D.*log(-y+yprime+zeta);

% Solve singularities:
if any(any((abs(y-yprime)<eps | abs(z-zprime)<eps) & abs(x-xprime)<eps))
    index = (abs(y-yprime)<eps | abs(z-zprime)<eps) & abs(x-xprime)<eps;
    Bxc(index) = 0;
end
if any(any(abs(zeta-z+zprime)<eps))
    index = abs(zeta-z+zprime)<eps;
    Byc(index) = D(index).*log(1./zeta(index));
end
if any(any(abs(zeta-y+yprime)<eps))
    index = abs(zeta-y+yprime)<eps;
    Bzc(index) = D(index).*log(1./zeta(index));
end

Bx = sum(Bxc,3);
By = sum(Byc,3);
Bz = sum(Bzc,3);

end

function [Bx,By,Bz] = cuboid_field_y(x,y,z,xprime,yprime,zprime,J)

Jy = J(2);

DD = Jy/(4*pi)*(-1).^(0:7)';
D = nan(size(x,1),size(x,2),8);
for ii = 1:8
  D(:,:,ii) = repmat(DD(ii),size(x,1),size(x,2));
end

% Solve field
zeta = sqrt((x-xprime).^2+(y-yprime).^2+(z-zprime).^2);
Bxc = D.*log(-z+zprime+zeta);
Byc = D.*atan((x-xprime).*(z-zprime)./((y-yprime).*zeta));
Bzc = D.*log(-x+xprime+zeta);

% Solve singularities:
if any(any(abs(zeta-z+zprime)<eps))
    index = abs(zeta-z+zprime)<eps;
    Bxc(index) = D(index).*log(1./zeta(index));
end
if any(any(abs(zeta-x+xprime)<eps))
    index = abs(zeta-x+xprime)<eps;
    Bzc(index) = D(index).*log(1./zeta(index));
end
if any(any((abs(x-xprime)<eps | abs(z-zprime)<eps) & abs(y-yprime)<eps))
    index = (abs(x-xprime)<eps | abs(z-zprime)<eps) & abs(y-yprime)<eps;
    Byc(index) = 0;
end

Bx = sum(Bxc,3);
By = sum(Byc,3);
Bz = sum(Bzc,3);

end

function [Bx,By,Bz] = cuboid_field_z(x,y,z,xprime,yprime,zprime,J)

Jz = J(3);

DD = Jz/(4*pi)*(-1).^(0:7)';
D = nan(size(x,1),size(x,2),8);
for ii = 1:8
  D(:,:,ii) = repmat(DD(ii),size(x,1),size(x,2));
end

% Solve field
zeta = sqrt((x-xprime).^2+(y-yprime).^2+(z-zprime).^2);
Bxc = D.*log(-y+yprime+zeta);
Byc = D.*log(-x+xprime+zeta);
Bzc = D.*atan((x-xprime).*(y-yprime)./((z-zprime).*zeta));

% Solve singularities:
if any(any(abs(zeta-y+yprime)<eps))
    index = abs(zeta-y+yprime)<eps;
    Bxc(index) = D(index).*log(1./zeta(index));
end
if any(any(abs(zeta-x+xprime)<eps))
    index = abs(zeta-x+xprime)<eps;
    Byc(index) = D(index).*log(1./zeta(index));
end
if any(any((abs(x-xprime)<eps | abs(y-yprime)<eps) & abs(z-zprime)<eps))
    index = (abs(x-xprime)<eps | abs(y-yprime)<eps) & abs(z-zprime)<eps;
    Bzc(index) = 0;
end

Bx = sum(Bxc,3);
By = sum(Byc,3);
Bz = sum(Bzc,3);

end