clc;clear;close all;

it=250000;
EbNo=-5:20;
sigma=1./sqrt(8*(10.^(EbNo./10)));

error = zeros(1,length(sigma));
BER=zeros(1,length(sigma));
BER_analytical=zeros(1,length(sigma));
BER_theoretical=zeros(1,length(sigma));
const_x=zeros(1,it);
const_y=zeros(1,it);

for k = 1:length(sigma)   
for i=1:it
    x=rand();
    
    %%%%%%%%% mapping of symbol %%%%%%%%%%%
    if x <= 0.0625
        symbol=1;                                                          
        A=[1 0];
    else if x <= 0.125 && x > 0.0625
            symbol=2;                                                     
            A=[0.923 0.38];
        else if x <= 0.1875 && x > 0.125
                symbol = 3;                                               
                A=[0.707 0.707];
            else if x <= 0.25 && x > 0.1875
                    symbol = 4;                                           
                    A=[0.38 0.923];
                else if  x <= 0.3125 && x > 0.25
                         symbol = 5;                                      
                         A=[0 1];
                    else if x <= 0.375 && x > 0.3125
                            symbol = 6;                                    
                            A=[-0.38 0.923];
                        else if x <= 0.4375 && x > 0.375
                                symbol = 7;                               
                                A=[-0.707 0.707];
                            else if x <= 0.5 && x > 0.4375
                                    symbol=8;
                                    A=[-0.923 0.38];
                                else if x <= 0.5625 && x > 0.5
                                        symbol=9;
                                        A=[-1 0];
                                    else if x <= 0.625 && x > 0.5625
                                            symbol=10;
                                            A=[-0.923 -0.38];
                                        else if x <= 0.6875 && x > 0.625
                                                symbol=11;
                                                A=[-0.707 -0.707];
                                            else if x <= 0.75 && x > 0.6875
                                                    symbol=12;
                                                    A=[-0.382 -0.923];
                                                else if x <= 0.8125 && x > 0.75
                                                        symbol=13;
                                                        A=[0 -1];
                                                    else if x <= 0.875 && x > 0.8125
                                                            symbol=14;
                                                            A=[0.382 -0.923];
                                                        else if x <= 0.9375 && x > 0.875
                                                                symbol=15;
                                                                A=[0.707 -0.707];
                                                            else symbol=16;
                                                                A=[0.923 -0.38];
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
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
        if theta < 11.25
            error(k)=error(k);
        else error(k)=error(k)+1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;
    %%%%%%%% BER and SER calculations %%%%%
    BER_analytical(k)=error(k)/(4*it);
    BER_theoretical(k)=.25*erfc(.137/(sigma(k)));
    
    SER_analytical(k)=error(k)/(it);
    SER_theoretical(k)=erfc(.137/(sigma(k)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
semilogy(EbNo,BER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,BER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('BER in log scale');
title('BER v/s EbNo for 16PSK');
legend('Simulation','Theoretical');
grid on;
figure;
semilogy(EbNo,SER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,SER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('SER in log scale');
title('SER v/s EbNo for 16-PSK');
legend('Simulation','Theoretical');
grid on;
figure;
scatter(const_x,const_y,'*');
title('Constellation for 16-PSK');