load('probabilities_all.mat');

% --- histograma de 20
distanciareal_20_hh = [];
distanciareal_20_hm = [];
distanciareal_20_hu = [];
distanciareal_20_hp = [];
for i=1:10000
    rand_indices_h = shuffle(1:101);
    particion_h = rand_indices_h(1:20);
    particion_h2 = rand_indices_h(21:40);
    rand_indices_m = shuffle(1:96);
    particion_m = rand_indices_m(1:20);
    rand_indices_u = shuffle(1:100);
    particion_u = rand_indices_u(1:20);
    rand_indices_p = shuffle(1:41);
    particion_p = rand_indices_p(1:20);
    
    meanH = mean(prob_h(:, particion_h), 2);
    meanH2 = mean(prob_h(:, particion_h2), 2);
    meanM = mean(prob_m(:, particion_m), 2);
    meanU = mean(prob_u(:, particion_u), 2);
    meanP = mean(prob_p(:, particion_p), 2);
    
    distanciareal_20_hh(i) = sqrt(JS(meanH, meanH2));
    distanciareal_20_hm(i) = sqrt(JS(meanH, meanM));
    distanciareal_20_hu(i) = sqrt(JS(meanH, meanU));
    distanciareal_20_hp(i) = sqrt(JS(meanH, meanP));
end

% figures
addpath('/home/usuario/disco1/proyectos/Figures/plot_matlab')

figure_size = 15;
font_size = 40;
save_path = '/home/usuario/Dropbox/papers/1-EEG-DOC/figuras/suplementarias/distancias_distribuciones';


binedges = 0:0.005:0.4;
color_m = [219, 170, 114]/255;
color_h = [137,166,201]/255;
color_u = [235, 142, 66]/255;
color_p = [140, 82, 35]/255;
face_alpha = 0.7;

figure
filename = fullfile(save_path, 'distancias_todos.eps');
set(gcf,'PaperUnits','centimeters','PaperPosition',[1 1 20 15])
set(0,'DefaultAxesFontSize',font_size);
set(0,'DefaultAxesFontName','Arial')

h = histogram(distanciareal_20_hh, 'BinEdges', binedges, 'Normalization', 'probability', 'EdgeColor', 'none', 'FaceColor', color_h, 'FaceAlpha', face_alpha);
hold on
histogram(distanciareal_20_hm, 'BinEdges', binedges, 'Normalization', 'probability', 'EdgeColor', 'none', 'FaceColor', color_m, 'FaceAlpha', face_alpha);
histogram(distanciareal_20_hu, 'BinEdges', binedges, 'Normalization', 'probability', 'EdgeColor', 'none', 'FaceColor', color_u, 'FaceAlpha', face_alpha);
histogram(distanciareal_20_hp, 'BinEdges', binedges, 'Normalization', 'probability', 'EdgeColor', 'none', 'FaceColor', color_p, 'FaceAlpha', face_alpha);
set(gca, 'Xtick', [0,0.1,0.2,0.3])
box off
xlim([0, 0.3])
ylim([0, 0.08])
print('-depsc', '-tiff', '-r300', filename);

%distance to controls
meanH = mean(prob_h, 2);
n_mcs = 96;
n_uws = 100;
n_healthy = 101;
distance_from_mcs = [];
distance_from_uws = [];
distance_from_healthy = [];
for i=1:n_healthy
    distance_from_healthy(i) = sqrt(JS(meanH,prob_h(:,i)));
end
for i=1:n_mcs
    distance_from_mcs(i) = sqrt(JS(meanH,prob_m(:,i)));
end
for i=1:n_uws
    distance_from_uws(i) = sqrt(JS(meanH,prob_u(:,i)));
end
