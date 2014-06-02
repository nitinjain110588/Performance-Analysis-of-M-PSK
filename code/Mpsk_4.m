clc
clear all
it=250000;
EbNo=-5:10;
sigma=sqrt(1./(4*10.^(0.1*EbNo)));

error = zeros(1,length(sigma));
BER_analytical=zeros(1,length(sigma));
SER_analytical=zeros(1,length(sigma));
const_x=zeros(1,it);
const_y=zeros(1,it);

for k = 1:length(sigma)   
for i=1:it
     x=rand();
     
     %%%%%%%%% mapping of symbol %%%%%%%%%%% 
     if x <= 0.25
        symbol=1;                                    
        A=[0.707 0.707];
        else if x <= 0.5 && x > 0.25
            symbol=2;                                
            A=[-0.707 0.707];
            else if  x <= 0.75 && x > 0.5
                symbol = 3;                          
                A=[-0.707 -0.707];
                else        
                   symbol = 4;                          
                   A=[0.707 -0.707];
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
    if theta < 45
       error(k)=error(k);
    else error(k)=error(k)+1;
    end
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%% BER and SER calculations %%%%%    
    BER_analytical(k)=error(k)/(2*it);
    SER_analytical(k)=error(k)/(it);
   
    BER_theoretical(k)=0.5*erfc(1/(2*sigma(k)));  
    SER_theoretical(k)=erfc(1/(2*sigma(k)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;
semilogy(EbNo,BER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,BER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('BER in log scale');
title('BER v/s EbNo for QPSK');
legend('Simulation','Theoretical');
grid on;
figure;
semilogy(EbNo,SER_analytical,'-red+','LineWidth',2);
hold on;
semilogy(EbNo,SER_theoretical,'-.blueo','LineWidth',2);
xlabel('EbNo in dB');
ylabel('SER in log scale');
title('SER v/s EbNo for QPSK');
legend('Simulation','Theoretical');
grid on;
figure;
scatter(const_x,const_y,'*');
title('Constellation for QPSK at 20dB');