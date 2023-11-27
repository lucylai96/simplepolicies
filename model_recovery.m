function model_recovery
% showing that models are recoverable

load data_final
load models_final

%            1      2            3          4          5            6        7      8
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};
models_labels = {'RLWM','No Cost (1\beta)','No Cost (6\beta)','Fixed (1\beta)','Fixed (6\beta)','Capacity','Value','**Capacity-Value'};


for m = 1:length(models)
load(['pr_' models{m} '.mat'])
pr_results(m) = results;
end
load models_final

figure; hold on;
for np = 1:size(results(8).x,2)
    nexttile; hold on;
    plot(pr_results(8).x(:,np), results(8).x(:,np), '.','MarkerSize',20)
    [r(np),p(np)] = corr(pr_results(8).x(:,np), results(8).x(:,np));
    lsline
    title(results(8).param(np).name)
end

%% Explaination of procedure
% We use this model recovery analysis to test our ability to distinguish our models.
% (1) We generate synthetic datasets from each of the 8 models, using the same
% stimuli that were shown to the 200 participants. To ensure that the statistics of
% the simulated data were similar to those of the participants, we used maximum-likelihood
% parameter estimates from our participants to generate the synthetic datasets.

% (2) We then repeated this procedure 10 times so we could average over randomness.
% In total, we generated 16000 synthetic datasets (8 generating models × 200 participants x 10 iterations).

% (3) Finally, we fit all 8 models to every dataset, using maximum-likelihood estimation
% as described before, and computed AIC, BIC, and PXP scores from the resulting fits.

% (4) For each of the 8 models fitted to the data-generating model, we found the lowest
% across-participant mean AIC and BIC (indicating that the model is a better fit to data), and
% the highest PXP and gave the "winning" model a tally of 1 and all other models a tally of 0.
% We plot the average of the tallies across all 10 iterations for each combination of
% data-generating model and fitted model.

%% (1 & 2) Generate synthetic datasets from each of the 8 models using fitted parameters (10x)
for m = 1:length(models)
    % simulate 10x
    for i = 1:10
        simdata = sim_fitted(models{m}, data, results); % model x iterations
        save(['simdata/mr_' models{m} '_' num2str(i) '.mat'],'simdata');
    end
end

%% (3) Fit 8 models to synthetic datasets
for m = 1:length(models)
    for i = 1:10
        load(['simdata/fitted_mr_' num2str(m) '_' num2str(i) '.mat']);
        %load lb
        save_mat = false;
        [results,bms_results] = fit_models(models, simdata, lb, save_mat); % fit all 8 models to the synthetic dataset
        save(['simdata/fitted_mr_' num2str(m) '_' num2str(i) '.mat'],'results','bms_results');
    end
end

%% (4) Plot summary statistics
% TO-DO: edit this from a previous project
win_aic = zeros(nModels,nModels,nTimes);
win_bic = zeros(nModels,nModels,nTimes);
win_pxp = zeros(nModels,nModels,nTimes);

for i = 1:nTimes
    for m = 1:nModels %1:8
        load(strcat('recovery_iter',num2str(i),'_model',num2str(m),'.mat'),'results','bms_results');
        
        % AIC
        aic = [results.aic]; % aic(aic>1e09) = NaN;
        med_aic(m,:) = nanmedian(aic);  % each row is all 8 fitted models to data generated from 1 model
        min_aic(m) = min(med_aic(m,:)); % each row is all 8 fitted models to data generated from 1 model
        diff_aic(m,:,i) = med_aic(m,:)-min_aic(m);
        win_model = find(med_aic(m,:)== min_aic(m));
        win_aic(m,win_model,i) = 1;
        % per subject
        [~,win_aic_subj(m,:,i)] = min(aic');
        
        % BIC
        bic = [results.bic]; %bic(bic>1e09) = NaN;
        %mean_bic(m,:) = nanmean(bic); % each row is all 8 fitted models to data generated from 1 model
        med_bic(m,:) = nanmedian(bic); % each row is all 8 fitted models to data generated from 1 model
        min_bic(m) = min(med_bic(m,:)); % each row is all 8 fitted models to data generated from 1 model
        diff_bic(m,:,i) = med_bic(m,:)-min_bic(m);
        win_model = find(med_bic(m,:)== min_bic(m));
        win_bic(m,win_model,i) = 1;
        % per subject
        [~,win_bic_subj(m,:,i)] = min(bic');
        
        % PXP
        pxp(m,:,i) = [bms_results.pxp];
        win_model = find(pxp(m,:,i)== max(pxp(m,:,i)));
        win_pxp(m,win_model,i) = 1;
        
    end
end

% plot
figure; hold on; subplot 131;
plot_diff_aic = nanmean(diff_aic,3);
plot_diff_aic(plot_diff_aic>100)=100;
imagesc(plot_diff_aic'); axis square;
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar;
title(c,'\Delta AIC');
disp(['Average diagonal AIC:' num2str(mean(diag(plot_diff_aic)))])

subplot 132;
plot_diff_bic = nanmean(diff_bic,3);
plot_diff_bic(plot_diff_bic>100)=100;
imagesc(plot_diff_bic'); axis square;
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar;
title(c,'\Delta BIC');
disp(['Average diagonal BIC:' num2str(mean(diag(plot_diff_bic)))])

subplot 133;
plot_pxp = nanmean(pxp,3);
imagesc(plot_pxp'); axis square
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar;
title(c,'PXP');
disp(['Average diagonal PXP:' num2str(mean(diag(plot_pxp)))])

set(gcf, 'Position',  [400, 400, 1200, 600])


% winning BIC and AIC
figure; hold on; subplot 131;
plot_win_aic = nanmean(win_aic,3);
imagesc(plot_win_aic'); axis square;
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar; xticks([1:8]); yticks([1:8])
title('Average winning AIC');
disp(['Average diagonal AIC:' num2str(mean(diag(plot_win_aic)))])

subplot 132;
plot_win_bic = nanmean(win_bic,3);
imagesc(plot_win_bic'); axis square;
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar; xticks([1:8]); yticks([1:8])
title('Average winning BIC');
disp(['Average diagonal BIC:' num2str(mean(diag(plot_win_bic)))])

subplot 133;
plot_win_pxp = nanmean(win_pxp,3);
imagesc(plot_win_pxp'); axis square;
xlabel('Data-generating model')
ylabel('Fitted model')
colormap(brewermap([],'Greys'))
c=colorbar; xticks([1:8]); yticks([1:8])
title('Average winning PXP');
disp(['Average diagonal PXP:' num2str(mean(diag(plot_win_pxp)))])
set(gcf, 'Position',  [400, 400, 1200, 600])
exportgraphics(gcf,[pwd '/figures/raw/model_recovery.pdf'], 'ContentType', 'vector');

%% by subject
for i = 1:nTimes
    for m = 1:8
        for j = 1:8
            percent_aic(m,j,i) = sum(win_aic_subj(m,:,i)==j);
            percent_bic(m,j,i) = sum(win_bic_subj(m,:,i)==j);
        end
    end
end
percent_aic = percent_aic./76 * 100;
percent_bic = percent_bic./76 * 100;


figure; hold on;
subplot 121;
imagesc(mean(percent_aic,3)')
axis square;
xlabel('Data-generating model')
ylabel('Fitted model'); title('AIC')
colormap(brewermap([],'Greys'))
c=colorbar; caxis([0 100]); xticks([1:8]); yticks([1:8])
title(c,'% subjects');

subplot 122;
imagesc(mean(percent_bic,3)')
axis square;
xlabel('Data-generating model')
ylabel('Fitted model'); title('BIC')
colormap(brewermap([],'Greys'))
c=colorbar; caxis([0 100]); xticks([1:8]); yticks([1:8])
title(c,'% subjects');
set(gcf, 'Position',  [400, 400, 800, 600])
exportgraphics(gcf,[pwd '/figures/raw/model_recovery2.pdf'], 'ContentType', 'vector');
end