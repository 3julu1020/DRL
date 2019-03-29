clc;
clear all;
distMBS=1000;  % distance between two macro BSs
%生成网络拓扑结构
%先确定macrocell的拓扑结构，先从确定站间距开始
%因为是19个小区，所有生成19个基站，每两个间距之间均为500m
[ macrox,macroy ] = generateMBS( distMBS);
 macroPoints=[macrox',macroy'];
picoNumPerBS=3;
[ picox,picoy ] = generatePBS( macroPoints,picoNumPerBS,distMBS ); % picoNumPerBS: the number of generating pico BSs in each macro BS
picoPoints=[ picox',picoy' ];
 macroVecters = findVecters( macroPoints, distMBS);
usersNumPerBS=120;
[userx,usery] = generatingUsers(macroPoints,picoPoints,usersNumPerBS,distMBS) ; % userNumPerBS: the number of generating users in each macro BS
figure;
hold on;
plot(macrox,macroy,'k<','MarkerSize',6);
plot(picox,picoy,'bo','MarkerSize',6);
scatter(userx(:),usery(:),'r*');
legend('macro','pico','user')
for i=1:length(macrox)
    h=line(macroVecters(i,:,1),macroVecters(i,:,2));
    set(h,'LineWidth',2.5);
    %text(macrox(i)+30,macroy(i)+30,num2str(i),'fontsize',12);
end
set(gca,'XTick',[],'YTick',[]);
box on;
% axis([-700,700,-700,700]);
