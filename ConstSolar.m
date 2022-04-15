
function [cinq, ceq] = const(x)

global Num Dem Flujo FDC Return
% Variable Matlab 		Unidad 	Descripción 
% CD	x(1)	US/MWh	LCOE
% fp	x(2)	% /100	Factor de Planta 
       %x(3)    KWh
       %x(4)    Opex
       %x(5)    Tasa de descuento
       %x(6)    VAN
       %x(7)    Capex
       %x(8)    Capacidad
       %x(9)    Plazo

CV=11; %costos variable %US$/MWh  
Inv_u=1000000;  %US$/MW
Cap=100;  %MW
CapEx=Inv_u*Cap;
r=0.1;
n=25;
FRC=r*(1+r)^n/((1+r)^n-1);
OM=20; %$/KW*year

% Restricciones
% ---------------- Nonlinear inequality constraints ------------------

cinq=[];

% ---------------- Nonlinear equality constraints -----------------------
%Metodo 1
%LCOE
%ceq(10)=Inv_u*FRC*(1/(x(2)*8760))+CV-x(1);

%otro metodo 
%ceq(1)=Cap*x(2)*8760-x(3); %calculo de la Energia anual

%METODO 2

 %kWh=Cap*x(2)*8760;


for j=1:n % vida util 
%ceq(1)=Cap*x(2)*8760-x(3); %kwh
x(3)=Cap*x(2)*8760; %kwh
%ceq(2)=CV*x(3)-x(4);% Opex Anual 
%x(4)=OM*1000*Cap;% Opex Anual 
x(4)=CV*x(3);% Opex Anual 
%ceq(2)=OM*1000*Cap-x(4);% Opex Anual 
Num(j)= x(4)/(1+x(5))^j; %Variable auxiliar del numerador 
Dem(j)= x(3)/(1+x(5))^j; %Variable auxiliar del denominador 
       % Flujo(j)=x(3)*x(1)-x(4); %flujo de caja
        %FDC(j)=Flujo(j)/(1+x(5))^j; %flujo de caja descontado
end
  %ceq(3)=Inv_u*x(8)-x(7); %Capex
  %ceq(1)=(CapEx+sum(Num))/sum(Dem)-x(1);  %Sensibilidad con respecto a la Td o FP
  ceq(1)=(x(6)*Cap+sum(Num))/sum(Dem)-x(1);  %Sensibilidad con respecto al capex 
  %ceq(5)=-x(7)+sum(Flujo)-x(6);  %VAN

%Return=irr(Flujo);


