function [userx,usery] = generatingUsers(macroPoints,picoPoints,usersNumPerBS,distMBS)
% Generating users'location for each macro BS
% macroPoints: macro BSs location
% usersNumPerBS: the number of users in each macro BS
% distMBS: the distance among macro BSs
macrox=macroPoints(:,1);
macroy=macroPoints(:,2);
picox=picoPoints(:,1);
picoy=picoPoints(:,2);
macroNum=length(macrox);
picoNum=length(picox);
userx=zeros(macroNum,usersNumPerBS);
usery=zeros(macroNum,usersNumPerBS);
for i=1:macroNum
    k=1;
    while k<=usersNumPerBS
        t=i+(k-1)*macroNum;
        userx(t)=sqrt(3)*distMBS*rand()/2-sqrt(3)*distMBS/4+macrox(i)-distMBS/(4*sqrt(3));
        usery(t)=distMBS*rand()-distMBS/2+macroy(i);
        if userx(t)>macrox(i)-distMBS/sqrt(3)&&userx(t)<macrox(i)-distMBS/(2*sqrt(3))
            if sqrt(3)*userx(t)+(distMBS/sqrt(3)-macrox(i))*sqrt(3)+macroy(i)-usery(t)<0
                userx(t)=userx(t)+sqrt(3)*distMBS/2;
                usery(t)=usery(t)-distMBS/2;
            elseif sqrt(3)*userx(t)+(distMBS/sqrt(3)-macrox(i))*sqrt(3)-macroy(i)+usery(t)<0
                userx(t)=userx(t)+sqrt(3)*distMBS/2;
                usery(t)=usery(t)+distMBS/2; 
            end
        end
        distance=sqrt((userx(t)-macrox(i))^2+(usery(t)-macroy(i))^2);
        picoUEdis=50;
        l=1;
        while l<=picoNum
            picoUEdis=sqrt((userx(t)-picox(l))^2+(usery(t)-picoy(l))^2);
            if picoUEdis<10
                break;
            end;
            l=l+1;
        end;
        if abs(usery(t)-macroy(i)) + abs(userx(t)-macrox(i))/sqrt(3)<= distMBS/sqrt(3)&&distance>35&&picoUEdis>10
            %userx(i,k)=userx(i,k)+macroposx(i);
            %usery(i,k)=usery(i,k)+macroposy(i);
            k = k+1;
        end
    end
end


