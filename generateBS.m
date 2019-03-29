function [ pointx,pointy ] = generateBS( distBS,BSType )
% Generating BSs' location
% distBS: the distance between two BSs
% BSType: 1,macro BS,0,pico BS

if BSType
    hexLen=distBS/sqrt(3);
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
                zp=Z+Len*exp(i*A);
                %             plot(zp,'k','linewidth',2);
                Z=Z+sqrt(3)*Len*exp(i*At(pp));
                %             text(real(Z),imag(Z),num2str(N),'fontsize',10);
                %             plot(real(Z),imag(Z),'ro');
                macrox(N)=real(Z);
                macroy(N)=imag(Z);
            end
        end
    end
    %     xlim([-6,6]*Len)
    %     ylim([-6.1,6.1]*Len)
    %     axis off;
    pointx=macrox;
    pointy=macroy;
else
    hexLen=distBS/sqrt(3);
    Len=hexLen;
    %     figure;
    %     axis square
    %     hold on;
    A=pi/3*[0:6];
    %     x=Len*exp(i*A)
    % plot(x,'k','linewidth',2);
    % text(0,0,'1','fontsize',10);
    picox(1)=0;
    picoy(1)=0;
    Z=0;
    N=1;
    At=-pi/2-pi/3*[0:6];
    for k=1:3;
        Z=Z+sqrt(3)*Len*exp(i*pi/6);
        for pp=1:6;
            for p=1:k;
                N=N+1;
                zp=Z+Len*exp(i*A);
                %             plot(zp,'k','linewidth',2);
                Z=Z+sqrt(3)*Len*exp(i*At(pp));
                %             text(real(Z),imag(Z),num2str(N),'fontsize',10);
                %             plot(real(Z),imag(Z),'ro');
                picox(N)=real(Z);
                picoy(N)=imag(Z);
            end
        end
    end
    %     xlim([-6,6]*Len)
    %     ylim([-6.1,6.1]*Len)
    %     axis off;
    picox=picox-distBS/10;
    picoy=picoy-distBS/10;
    pointx=picox;
    pointy=picoy;
end
end

