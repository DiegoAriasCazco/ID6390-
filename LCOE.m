% Evaluación  de Proyectos Eléctricos 
% Costo de desarrollo 
% Versión 1.0
% Autor: Diego Arias

clear; clc;

global Num Dem Flujo FDC Return



       %
%Datos:
%fp=0.85;   %Factor de Planta 
%t= 0.2;  %Tasa de Impuesto %
%r=0.1;   %Tasa de descuento %
%n=20;    %Vida Util
%T=8760;  %Horas contenidas en el año
%Cp=9375;      %Precio de la potencia [MUS$/MW*mes]
%k=0.85;  %Prorrata entre potencia firme y capacidad instalada. 
%Dep=Inv/n;  %Depreciación 


% 
% % ---------------- Inequality constraints ---------------------
 A = [ ]; b =[ ]; 
% % ------------------ Equality constraints ---------------------
  Aeq = []; beq = [];
% % ------------------ Parametric constraints -------------------    

% Variable Matlab 		Unidad 	Descripción 
% CD	x(1)	US/MWh	LCOE
% fp	x(2)	% /100	Factor de Planta 
       %x(3)    KWh
       %x(4)    Opex
       %x(5)    Tasa de descuento
       %x(6)    Capex
   
% FP:  fijo: 0.2, y variable de 0.05 y 0.9,
% Capex: 1e6 fijo, y variable de 0.5 a 1.5 
% TD: fijo:0.1 y variable de 0.5 a 0.15  

lb = [15  0.2 0 0 0.1 0.5e6];  %limites inferiores de las variables 
ub = [200 0.2 1e9 1e10 0.1 1.5e6]; % Limites superiores de las variables 

x0=(lb+ub)/2;

nvars=6;

options = optimoptions('gamultiobj');
%% Modify options setting
%options = optimoptions(options,'PopulationSize', PopulationSize_Data);
%options = optimoptions(options,'ParetoFraction', ParetoFraction_Data);
options = optimoptions(options,'MigrationDirection', 'both');
% options = optimoptions(options,'InitialPopulationRange', [-0;1]);
%options = optimoptions(options,'MigrationInterval', MigrationInterval_Data);
%options = optimoptions(options,'MigrationFraction', MigrationFraction_Data);
%options = optimoptions(options,'FunctionTolerance', 1e-4,'MaxStallGenerations',300);
%options = optimoptions(options,'ParetoFraction', 1);
%options = optimoptions(options,'CrossoverFcn', { @crossoverheuristic, 0.8});
%options = optimoptions(options,'CrossoverFcn', { @crossoverscattered});
options = optimoptions(options,'CreationFcn', @gacreationnonlinearfeasible);
options = optimoptions(options,'SelectionFcn', {  @selectiontournament [] });
options = optimoptions(options,'HybridFcn', {  @fgoalattain [] });
options = optimoptions(options,'Display', 'iter');
%options = optimoptions(options,'PlotFcn', {@gaplotpareto,@gaplotscorediversity});
%options = optimoptions(options,'PlotFcn', {@gaplotpareto,@gaplotdistance @gaplotgenealogy @gaplotscorediversity @gaplotselection @gaplotstopping @gaplotpareto @gaplotparetodistance @gaplotrankhist @gaplotspread});
%options = optimoptions(options,'PlotFcn', {@gaplotpareto, @gaplotscorediversity @gaplotselection @gaplotpareto @gaplotparetodistance @gaplotrankhist @gaplotspread});
options = optimoptions(options,'UseVectorized', false);
options = optimoptions(options,'UseParallel', true);
[x,fval,exitflag,output,population,score] = ...
gamultiobj(@multiobj,nvars,[],[],[],[],lb,ub,@(x)ConstSolar(x),options);

% 
figure(1)
axes1 = axes('Parent',figure(1));
hold(axes1,'on');

%plot1=plot(x(:,2),x(:,1),'LineWidth',1.5);
plot1=plot((x(:,6)/1e6)*100,x(:,1),'LineWidth',1.5); %Para capex
set(plot1(1),'DisplayName','Frontera de Pareto','Marker','*',...
    'LineStyle','none','LineWidth',1.5,'Color',[1 0 0]);
    
%xlabel('Factor de Planta (%100)')
%xlabel('Tasa de descuento (%100)')
xlabel('CAPEX (%)')
ylabel('LCOE [USD$/MWh]')
grid(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',16,'XMinorGrid','on','YMinorGrid','on');
legend(axes1,'show');

