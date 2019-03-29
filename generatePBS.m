function [ picox,picoy ] = generatePBS( macroPoints,picoNumPerBS,distMBS )
% picox,picoy: pico BSs' location,generate one pico BS in each macro cell
% macroPoint: macro BSs' location
% distMBS: the distance among macro BSs
% picoNumPerBS: the number of generating pico BS in each macro BS
macrox=macroPoints(:,1);
macroy=macroPoints(:,2);
macroNum=length(macrox);
for i=1:macroNum
    k=1;
    while k<=picoNumPerBS
        t=i+(k-1)*macroNum;
        picox(t)=sqrt(3)*distMBS*rand()/2-sqrt(3)*distMBS/4+macrox(i)-distMBS/(4*sqrt(3));
        picoy(t)=distMBS*rand()-distMBS/2+macroy(i);
        if picox(t)>macrox(i)-distMBS/sqrt(3)&&picox(t)<macrox(i)-distMBS/(2*sqrt(3))
            if sqrt(3)*picox(t)+(distMBS/sqrt(3)-macrox(i))*sqrt(3)+macroy(i)-picoy(t)<0
                picox(t)=picox(t)+sqrt(3)*distMBS/2;
                picoy(t)=picoy(t)-distMBS/2;
            elseif sqrt(3)*picox(t)+(distMBS/sqrt(3)-macrox(i))*sqrt(3)-macroy(i)+picoy(t)<0
                picox(t)=picox(t)+sqrt(3)*distMBS/2;
                picoy(t)=picoy(t)+distMBS/2;
            end
        end
        distance=sqrt((picox(t)-macrox(i))^2+(picoy(t)-macroy(i))^2);%��pico����macro�ľ���
        h=1;
        judge=0;
        picodis=50;
        while h<=i
            l=1;
            while l<k
                picodis=sqrt((picox(t)-picox(h))^2+(picoy(t)-picoy(h))^2);%�����Ѿ����ɵ�pico��ȷ��pico֮��ľ���
                if picodis<40%����о���С��40�ģ�����������������ѭ������������pico
                    judge=1;
                    break;
                end;
                l=l+1;
            end
            if judge==1
                break;
            end
            h=h+1;
        end;
        if abs(picox(t)-macrox(i)) + abs(picoy(t)-macroy(i))/sqrt(3)<= distMBS/sqrt(3)&&distance>75&&picodis>40 %ֻ���������������ģ�������������������1�������������ڣ����Ǻͺ��վ�ľ������75������pico֮��ľ������40
            % picox(i,j)=picox(i,j)+macroposx(i);%�����ԵĻ��������Ϻ��վ��λ�ã�����ÿ��λ�õ�pico�����ɽ���
            %picoy(i,j)=picoy(i,j)+macroposy(i);
            k = k+1;
        end
    end
end
end

