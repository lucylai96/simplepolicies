function [results] = parallel_cluster
% for fitting the data

p = parpool(11); % start parallel pool
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv','capacity_pg','value_pg','pg'};

parfor i = 1:11
    results = fit_models_rt_cluster(models{i});
end

delete(p)

% consolidate all the model fits
for m = 1:length(models)
    load([models{m} '.mat'])
    new_results(m) = results;
end

% save data
results = new_results; 
bms_results = mfit_bms(results,1); % bayesian model comparison
save('models_final.mat','results','bms_results');