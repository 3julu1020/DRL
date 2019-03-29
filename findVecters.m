function vecters = findVecters( points, dist)
% Given the center of hexagons,finding its six vecters
%  points: center points of hexagons
%  dist: distance among the centers of hexagons
L=size(points,1);
vecters=zeros(L,7,2);
a=dist/sqrt(3);
for i=1:L
    x=points(i,1);
    y=points(i,2);
    vecters(i,1,1)=x+a;
    vecters(i,1,2)=y;
    vecters(i,2,1)=x+a/2;
    vecters(i,2,2)=y+a*sqrt(3)/2;
    vecters(i,3,1)=x-a/2;
    vecters(i,3,2)=y+a*sqrt(3)/2;
    vecters(i,4,1)=x-a;
    vecters(i,4,2)=y;
    vecters(i,5,1)=x-a/2;
    vecters(i,5,2)=y-a*sqrt(3)/2;
    vecters(i,6,1)=x+a/2;
    vecters(i,6,2)=y-a*sqrt(3)/2;
    vecters(i,7,1)=x+a; % in order to plot close hexagon,
    vecters(i,7,2)=y;   
end
end

