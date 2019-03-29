function [ macrox,macroy ] = generateMBS( distMBS)
% Generating Macro BSs' location
% distMBS: the distance between two macro BSs
hexLen=distMBS/sqrt(3);
Len=hexLen;
%     figure;
%     axis square
%     hold on;
A=pi/3*[0:6];
%     x=Len*exp(i*A)
% plot(x,'k','linewidth',2);
% text(0,0,'1','fontsize',10);
macrox(1)=0;
macroy(1)=0;
Z=0;
N=1;
At=-pi/2-pi/3*[0:6];
for k=1:3;
    Z=Z+sqrt(3)*Len*exp(i*pi/6);
    for pp=1:6;
        for p=1:k;
            N=N+1;
            if N<=19 % generate 19 macro cells
                zp=Z+Len*exp(i*A);
                % plot(zp,'k','linewidth',2);
                Z=Z+sqrt(3)*Len*exp(i*At(pp));
                % text(real(Z),imag(Z),num2str(N),'fontsize',10);
                %  plot(real(Z),imag(Z),'ro');
                macrox(N)=real(Z);
                macroy(N)=imag(Z);
            end
        end
    end
end
%     xlim([-6,6]*Len)
%     ylim([-6.1,6.1]*Len)
%     axis off;
end

