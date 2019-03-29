clc
clear all;
%初始化一些参数
avethroughput=0;s=0;g=0;
picothroughput=0;
averagepicoput2=0;
averagemacroput2=0;
macrothroughput=0;
totalthroughput=0;
macroput2=0;
picoput2=0;
sectorc2=0;
for time=1:1
    picounity=0;
j=1;N=30;k=1;l=1;f=0;M=120;
%生成网络拓扑结构
%先确定macrocell的拓扑结构，先从确定站间距开始
%因为是19个小区，所有生成19个基站，每两个间距之间均为500m
macroposx=[0  250*sqrt(3)  0  -250*sqrt(3) -250*sqrt(3) 0  250*sqrt(3) 500*sqrt(3)  500*sqrt(3) 250*sqrt(3) ...
              0 -250*sqrt(3) -500*sqrt(3) -500*sqrt(3) -500*sqrt(3) -250*sqrt(3) 0 250*sqrt(3) 500*sqrt(3)];%下标从1开始到19的每个宏基站的横坐标
macroposy=[0 -250 -500 -250 250 500 250 0 -500 -750 -1000 -750 -500 0 500 750 1000 750 500];%下标从1开始到19的每个宏基站的纵坐标
%生成picocell的位置，每个macrocell的位置周围都有N个picocell，随机分布，布置思路是根据在属于范围内的点即可
picox=zeros(19,N);picoy=zeros(19,N);
II=zeros(1,19);
for i=1:19 
    j=1;
    while j<=N     
        picox(i,j)=(1000/sqrt(3)*rand()-500/sqrt(3))+macroposx(i);%随机生成横坐标
        picoy(i,j)=(500*rand()-250)+macroposy(i);%随机生成纵坐标
        distance=sqrt((picox(i,j)-macroposx(i))^2+(picoy(i,j)-macroposy(i))^2);%算pico距离macro的距离
        h=1;judge=0;
        picodis=50;
        while h<=i
            l=1;
           while l<j
                 picodis=sqrt((picox(i,j)-picox(h,l))^2+(picoy(i,j)-picoy(h,l))^2);%遍历已经生成的pico，确认pico之间的距离
                 if picodis<40%如果有距离小于40的，则不满足条件，跳出循环，重新生成pico              
                    judge=1;
                    break;
                 end;
                 l=l+1;
           end;
           %h=h+1;
           if judge==1
               break;
           end
           h=h+1;
        end;
        if abs(picox(i,j)-macroposx(i)) + abs(picoy(i,j)-macroposy(i))/sqrt(3)<= 500/sqrt(3)&&distance>75&&picodis>40 %只有满足三个条件的，才能算是生成正常。1是在正六边形内，二是和宏基站的距离大于75，三是pico之间的距离大于40
           % picox(i,j)=picox(i,j)+macroposx(i);%若可以的话，叠加上宏基站的位置，生成每个位置的pico，生成结束
            %picoy(i,j)=picoy(i,j)+macroposy(i);
            j = j+1;
        end
    end 
    II(i)=i;
end
%生成用户的位置，每个macrocell的位置周围都有30个用户。所有采用的生成思路和验证思路和pico一模一样的，不再赘述
userx=zeros(19,M);usery=zeros(19,M);

for i=1:19
    k=1;
    while k<=M
        userx(i,k)=(1000/sqrt(3)*rand()-500/sqrt(3))+macroposx(i);
        usery(i,k)=(500*rand()-250)+macroposy(i);
        distance=sqrt((userx(i,k)-macroposx(i))^2+(usery(i,k)-macroposy(i))^2);
        h=1;judge=0;
        picoUEdis=50;
        while h<=19
            l=1;
           while l<=N
               picoUEdis=sqrt((userx(i,k)-picox(h,l))^2+(usery(i,k)-picoy(h,l))^2);
               if picoUEdis<10
                   judge=1;
                   break;
               end;
               l=l+1;
           end;
           if judge==1
               break;
           end
           h=h+1;
        end
        if abs(userx(i,k)-macroposx(i)) + abs(usery(i,k)-macroposy(i))/sqrt(3)<= 500/sqrt(3)&&distance>25&&picoUEdis>10
          %userx(i,k)=userx(i,k)+macroposx(i);
          %usery(i,k)=usery(i,k)+macroposy(i);
          k = k+1;
        end
     end
end   
bandwidth=10^7;
%CF=2*10^9;
%macropower=10^4.6/1000;
%picopower=1;
%噪声的单位是DB，怎么搞
%noise=9;
%formulas for path loss from macro to UE and pico to UE
%pico to UE, result is db
%L=140.7+36.7*log10(D);
%macro to UE, result is db
%PL=128.1+37.6*log10(d);
%antenna configuration of pico at any direction
%picoantgain=10^0.5;
%antenna configuration of macro at any direction
%macroantgain=-min(12*(theta/65),20);
%calculate the fast fading parameter for macro and pico
macrofading=raylrnd(1,[19 19*M]);
picofading=raylrnd(1,[19*N 19*M]);
%求出SINR的公式,初始化SINR为一个1*570的矩阵，每一个用户有着唯一的SINR
SINR=zeros(19, M);
power=zeros(19,M);
powermw=zeros(19,M);
%theta=zeros(19,30);
%尝试去求一个UE所接收功率的大小
%对于macro的UE来说
 userxx=zeros(19,M);
 useryy=zeros(19,M);
 picoxx=zeros(19,N);
 picoyy=zeros(19,N);
 recordi=zeros(1,600);
 recordk=zeros(1,600);
 recordj=zeros(1,600);
for i=1:19
    for k=1:M
    userxx(i,k)=userx(i,k)-macroposx(i);
    useryy(i,k)=usery(i,k)-macroposy(i);    
    d=sqrt(userxx(i,k)^2+useryy(i,k)^2)/1000;
    %theta=ATAND(useryy(i,k)/userxx(i,k));
    %分不同的情况去讨论天线的增益，然后再根据路损公式和天线增益算出macro能给一个UE的power
    if userxx(i,k)>0
        theta=atand(useryy(i,k)/userxx(i,k));
        if theta>0
            A=-min(12*(abs(theta-60)/65)^2,20);
        else 
            A=-min(12*(abs(theta+60)/65)^2,20);
        end
    else
        theta=atand(useryy(i,k)/userxx(i,k));
        theta2=theta+180;
        if abs(theta) <60
            A=-min(12*(abs(theta)/65)^2,20);
        elseif theta>60
            A=-min(12*(abs(theta-60)/65)^2,20);
        else
            A=-min(12*(abs(theta+60)/65)^2,20);
        end
    end
    ddd=46+14-(128.1+37.6*log10(d))+A;
    power(i,k)=10^(ddd/10)*macrofading(i,i*k);
    %遍历一遍pico，算出pico能给UE的功率，谁给UE的功率大，UE就连接着谁
    j=1;
    
    while j<=N
        picoxx(i,j)=picox(i,j)-macroposx(i);
        picoyy(i,j)=picoy(i,j)-macroposy(i);
        D=sqrt((userxx(i,k)-picoxx(i,j))^2+(useryy(i,k)-picoyy(i,j))^2)/1000;
        p=30+5-(140.7+36.7*log10(D));
        if 10^(p/10)*picofading(i*j,i*k)>power(i,k);
            power(i,k)=10^(p/10)*picofading(i*j,i*k);
            sss=p;
            s=i;
            g=j;
            %f=f+1;
        end       
        j=j+1;
    end
    
    
    %算出到底有几次UE不是连接着macro的
    if power(i,k)~=10^(ddd/10)*macrofading(i,i*k)
        
        f=f+1;
        recordi(f)=i;
        recordk(f)=k;
        recordj(f)=g;
    end
    powermw(i,k)=power(i,k);
    end
 end

%既然现在已经计算出了接收功率，那么现在只要计算出干扰即可
%首先计算出macrocell对其的干扰
Imw=zeros(19,M);

Im=zeros(19,M,19);
Ip=zeros(19,M,19,N);
userxxx=zeros(19,M,19);
for i=1:19
    for k=1:M
        for m=1:19
            d2=sqrt((userx(i,k)-macroposx(m))^2+(usery(i,k)-macroposy(m))^2)/1000;
            %theta2=atand((usery(i,k)-macroposy(m))/(userx(i,k)-macroposx(m)));
            userxxx(i,k,m)=userx(i,k)-macroposx(m);
            %先算出macro对UE的干扰，也是分情况讨论天线的增益
            if userxxx(i,k,m)>0
               theta2=atand((usery(i,k)-macroposy(m))/(userx(i,k)-macroposx(m)));
               A2=-min(12*(abs(theta2-60)/65)^2,20);
               A3=-min(12*(abs(theta2+60)/65)^2,20);
               A4=-min(12*(abs(theta2-180)/65)^2,20);
            else
                theta2=atand((usery(i,k)-macroposy(m))/(userx(i,k)-macroposx(m)));
                theta3=theta+180;
                A2=-min(12*(abs(theta2+60)/65)^2,20);
                A3=-min(12*(abs(theta2-60)/65)^2,20);
                A4=-min(12*(abs(theta2)/65)^2,20);
            end
            %A2=-min(12*abs(theta2/65),20)-min(12*abs(theta2+120/65),20)-min(12*abs(theta2-120/65),20);
            macrointerfe1=46+14-(128.1+37.6*log10(d2))+A2;
            macrointerfe2=46+14-(128.1+37.6*log10(d2))+A3;
            macrointerfe3=46+14-(128.1+37.6*log10(d2))+A4;%每一个macro的干扰
            Im(i,k,m)=(10^(macrointerfe1/10)+10^(macrointerfe2/10)+10^(macrointerfe3/10))*macrofading(m,i*k);%在加的时候，要进行实数化
            Imw(i,k)=Imw(i,k)+Im(i,k,m);
        end
    end
end
for i=1:19
    for k=1:M
        for m=1:19
            for n=1:N
                d3=sqrt((userx(i,k)-picox(m,n))^2+(usery(i,k)-picoy(m,n))^2)/1000;
                picointerfe=30+5-(140.7+36.7*log10(d3));
                Ip(i,k,m,n)=10^(picointerfe/10)*picofading(m*n,i*k);
                Imw(i,k)=Imw(i,k)+Ip(i,k,m,n);
            end
        end
        %I(i,k)=I(i,k)-powermw(i,k);
    end
end
I=zeros(19,M);
for i=1:19
    for k=1:M
        I(i,k)=Imw(i,k)-powermw(i,k);
        
    end
end

%所以现在已经算出来了对于任意一个UE（i,k)来说它的power（i,k）和它的干扰I（i,k），直接求出性噪比即可。
SINRCDF=zeros(19,M);
%CDF=zeros(1,19*30);
for i=1:19
    for k=1:M
        SINR(i,k)=powermw(i,k)/I(i,k);
        SINRCDF(i,k)=10*log10(SINR(i,k));
        %SINRCDF(i*k)=SINR(i,k);

    end
end
CDF=SINRCDF(:);
%reshape(SINRCDF,i*k,1);

%cdfplot(CDF);
C=zeros(19,M);
%sectorc=0;
%p=0;
indibandwidth=zeros(1,19);
q=0;picoput=0;macroput=0;sectorc=0;
for i=1:19
    p=0;
    for o=1:f
            if i==recordi(o)
                p=p+1;               
            end
    end
        indibandwidth(i)=bandwidth/(30-p);
end
picobandwidth=zeros(19,N);
for i=1:19   
   for j=1:N
       q=0;
      for o=1:f
         if i==recordi(o)&&j==recordj(o)
             q=q+1;
         end
      end
      if q~=0
         picobandwidth(i,j)=bandwidth/q;
      end
   end
end

for i=1:19   
   for k=1:M
     xx=0;
     for o=1:f
        if i==recordi(o)&&k==recordk(o)
            q=q+1;
            C(i,k)=picobandwidth(i,recordj(o))*log2(1+SINR(i,k));
            picoput=C(i,k)+picoput;
            sectorc=sectorc+C(i,k);
            xx=1;
            break;
        end
     end
     if xx~=1
        C(i,k)=indibandwidth(i)*log2(1+SINR(i,k));
        macroput=macroput+C(i,k);
        sectorc=sectorc+C(i,k);
     end
   end
end
averagepicoput=0;
if q~=0
   averagepicoput=picoput/q;
end
if time==1
    averagepicoput2=averagepicoput;
    picoput2=picoput;
end
averagepicoput2=(averagepicoput+averagepicoput2)/2;
picoput2=(picoput2+picoput)/(2*19*3);
averagemacroput=macroput/(19*M-q);
if time==1
    averagemacroput2=averagemacroput;
    macroput2=macroput;
end
averagemacroput2=(averagemacroput+averagemacroput2)/2;
macroput2=(macroput2+macroput)/(2*19*3);
if time==1
    sectorc2=sectorc;
end
sectorc2=(sectorc2+sectorc)/(19*2*3);
avec=sectorc/(19*M);
if time==1
    avethroughput=avec;
end
avethroughput=(avethroughput+avec)/2;
attachment=f/(19*M);
if time==1
    attachment2=attachment;
end
attachment2=(attachment+attachment2)/2;
end
cdfplot(CDF);
%scatter(picox,picoy);
figure;
hold on;

plot(picox,picoy,'rs');
plot(userx,usery,'bs');
plot(macroposx,macroposy,'gs');
%grid on;
hold off;


















