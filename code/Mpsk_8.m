clc;clear;close all;

it=250000;
EbNo=-5:10;
sigma=1./sqrt(6*(10.^(EbNo./10)));

error = zeros(1,length(sigma));
BER=zeros(1,length(sigma));
const_x=zeros(1,it);
const_y=zeros(1,it);

for k = 1:length(sigma)   
for i=1:it
    x=rand();
    %%%%%%%%% mapping of symbol %%%%%%%%%%% 
    if x <= 0.125
        symbol=1;                                                          % symbol 1 = 000
        A=[1 0];
    else if x <= 0.25 && x > 0.125
            symbol=2;                                                      % symbol 2 = 010
            A=[0.707 0.707];
        else if x <= 0.375 && x > 0.25
                symbol = 3;                                                % symbol 3 = 110
                A=[0 1];
            else if x <= 0.5 && x > 0.375
                    symbol = 4;                                            % symbol 4 = 100
                    A=[-0.707 0.707];
                else if  x <= 0.625 && x > 0.5
                         symbol = 5;                                       % symbol 5 = 101
                         A=[-1 0];
                    else if x <= 0.75 && x > 0.625
                            symbol = 6;                                    % symbol 6 = 111
                            A=[-0.707 -0.707];
                        else if x <= 0.875 && x > 0.75
                                symbol = 7;                                % symbol 7 = 011
                                A=[0 -1];
                            else symbol=8;                                 % symbol 8 = 001
                                 A=[0.707 -0.707];
                            end
                        end
                    end
                end               
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%% addition of noise %%%%%%%%%%%
    Inoise = sigma(k) * randn;
    Qnoise = sigma(k) * randn;
    Ircv = A(1) + Inoise;
    Qrcv = A(2) + Qnoise;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
     B=[Ircv Qrcv];
     const_x(i)=B(1);
     const_y(i)=B(2);
     
     %%%%%%%% Symbol Detection %%%%%%%%%%%%%
     B_Mag=sqrt((Ircv*Ircv)+(Qrcv*Qrcv));
     C=dot(A,B);
     C=C/B_Mag;
     theta=acosd(C);
     if theta < 22.5
         error(k)=error(k);
     else error(k)=error(k)+1;
     end
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;
    %%%%%%%% BER and SER calculations %%%%%
    BER_analytical(k)=error(k)/(3*it);
    BER_theoretical(k)=(1/3)*erfc(0.27/(sigma(k)));
    
    SER_analytical(k)=error(k)/(it);
    SER_theoretical(k)=erfc(0.27/(sigma(k)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
semilogy(EbNo,BER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,BER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('BER in log scale');
title('BER v/s EbNo for 8PSK');
legend('Simulation','Theoretical');
grid on;
figure;
semilogy(EbNo,SER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,SER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('SER in log scale');
title('SER v/s EbNo for 8-PSK');
legend('Simulation','Theoretical');
grid on;
figure;
scatter(const_x,const_y,'*');
title('Constellation for 8-PSK');