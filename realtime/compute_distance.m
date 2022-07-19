eeglab

%load('realtime_acute.mat');
load('realtime_all.mat');
%load('realtime_patients.mat');

n_a = 20;
n_b = 21;
Distanciarandom = [];
for rep = 1:10000
	datos = shuffle(prob_p_offline, 2);
	mitadA = datos(:,1:n_a);
	mitadB = datos(:,n_a+1:end);	
	
	%hA = hist(mitadA);
	%hB = hist(mitadB);
	hA = mean(mitadA, 2);
    hB = mean(mitadB, 2);
    
	Distanciarandom(rep) = sqrt(JS(hA,hB));
end

% --- histograma de 40 (sujetos contra mismos sujetos)
% hDatos = mean(prob_p_offline, 2);
% hrealtime = mean(prob_p_realtime, 2);
% distanciareal = sqrt(JS(hDatos, hrealtime));

% --- histograma de 20 (sujetos contra mismos sujetos)
distanciareal_20 = [];
for i=1:10000
    rand_indices = shuffle(1:41);
    mitad = rand_indices(1:20);
    
    hDatos = mean(prob_p_offline(:, mitad), 2);
    hrealtime = mean(prob_p_realtime(:, mitad), 2);
    
    distanciareal_20(i) = sqrt(JS(hDatos, hrealtime));
end
mean_distreal20 = mean(distanciareal_20);
std_distreal20 = std(distanciareal_20);

% --- histograma de 20 (sujetos contra OTROS sujetos)
distanciareal_20_distintos = [];
for i=1:10000
    rand_indices = shuffle(1:41);
    mitad = rand_indices(1:20);
    rand_indices2 = shuffle(1:41);
    mitad2 = rand_indices2(1:20);
    
    hDatos = mean(prob_p_offline(:, mitad), 2);
    hrealtime = mean(prob_p_realtime(:, mitad2), 2);
    
    distanciareal_20_distintos(i) = sqrt(JS(hDatos, hrealtime));
end

% --- histograma de 1 (sujetos contra mismos sujetos)
% distanciareal_sub = [];
% for i=1:length(prob_p_offline)
%     hDatos = prob_p_offline(:,i);
%     hrealtime = prob_p_realtime(:,i);
%     distanciareal_sub(i) = sqrt(JS(hDatos, hrealtime));
% end
% mean_distreal = mean(distanciareal_sub);
% std_distreal = std(distanciareal_sub);

% figures

addpath('/home/usuario/disco1/proyectos/Figures/plot_matlab')

figure_size = 15;
font_size = 25;
save_path = '/home/usuario/Dropbox/papers/1-EEG-DOC/figuras/figura1/realtime/distribucion';


%distancia JS
histogram(Distanciarandom)
hold on
plot([distanciareal,distanciareal],[0,2000])
xlim([0, 0.02])
ylim([0 1600])
xlabel('JS')

%distancia sqrt(JS)
histogram(Distanciarandom)
hold on
plot([distanciareal,distanciareal],[0,1000])
xlim([0, 0.2])
ylim([0 1000])
xlabel('sqrt(JS)')

%distancia mean +- std
histogram(Distanciarandom)
hold on
plot([mean_distreal-std_distreal,mean_distreal-std_distreal],[0,1000])
plot([mean_distreal,mean_distreal],[0,1000])
plot([mean_distreal+std_distreal,mean_distreal+std_distreal],[0,1000])
xlim([0, 0.2])
ylim([0 1000])
xlabel('sqrt(JS)')

%distancia 20
figure

filename = fullfile(save_path, 'particion_20_acute.eps');
%set_figure_size(figure_size);
set(gcf,'PaperUnits','centimeters','PaperPosition',[1 1 20 15])
set(0,'DefaultAxesFontSize',30);
set(gca,'DefaultAxesFontName','Helvetica')

alpha = 0.2;
color = [0, 0, 0]/255;
color_vert = [0, 0, 0]/255;
color_hist = [100, 100, 100]/255;
max_vert = 0.1;
h = histogram(Distanciarandom, 'LineStyle', 'none', 'Normalization','probability', 'FaceColor', color_hist);
hold on
fill([mean_distreal20-std_distreal20,mean_distreal20-std_distreal20,mean_distreal20+std_distreal20,mean_distreal20+std_distreal20],[0,max_vert,max_vert,0],color,'FaceAlpha',alpha,'LineStyle', 'none');
%plot([mean_distreal20-std_distreal20,mean_distreal20-std_distreal20],[0,1000])
plot([mean_distreal20,mean_distreal20],[0,max_vert],'color',color_vert,'Linewidth',2)
%plot([mean_distreal20+std_distreal20,mean_distreal20+std_distreal20],[0,1000])
xlim([0, 0.2])
ylim([0 max_vert])
set(gca, 'Xtick', [0, 0.05, 0.1, 0.15, 0.2])
box off
print('-depsc', '-tiff', '-r300', filename);

%compute p value for acute
from = 6;
p_val_acute = sum(h.Values(from:end));

%compute p value for patients
from = 16;
p_val_patients = sum(h.Values(from:end));

%compute p value for all
from = 36;
p_val_all = sum(h.Values(from:end));

%distanciarealnormalizada = (distanciareal - mean(Distanciarandom)) / std(Distanciarandom);