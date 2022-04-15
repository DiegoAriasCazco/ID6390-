function f = multiobj(x)

%Ok LCOE vs FP 
 %  f(1) =x(2); %min FP
 %  f(2) =x(1); %min LCOE 

%  f(1) =-x(5); % max Tasa de descuento
%  f(2) =x(1); % min LCOE 

 
   f(1) =-x(6); % max Capex 
   f(2) =x(1); % min LCOE 



% Variable Matlab 		Unidad 	Descripción 
% CD	x(1)	US/MWh	LCOE
% fp	x(2)	% /100	Factor de Planta 
       %x(3)    KWh
       %x(4)    Opex
       %x(5)    Tasa de descuento
       %x(6)    VAN


