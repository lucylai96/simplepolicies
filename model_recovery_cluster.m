function model_recovery_cluster

%p = parpool(8);
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};
load lb_final.mat
load data_final.mat

parfor m = 1:length(models)
    for i = 1
        load(['simdata/mr_' models{m} '_' num2str(i) '.mat']);
        save_mat = true;
        savepath = ['simdata/fitted_mr_' models{m} '_' num2str(i) '.mat'];
        fit_models_rt(models, simdata, lb, save_mat, savepath); % fit all 8 models to the 1 synthetic dataset
    end
end

end