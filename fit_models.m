function [results,bms_results] = fit_models(models, data, lb, save_mat)
%{
    Fit data to the models you specify.
%}
if nargin < 3
    save_mat = false;
end

% models = {'nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};

addpath('/Users/lucy/Library/CloudStorage/GoogleDrive-lucylai.lxl@gmail.com/My Drive/Harvard/Projects/mfit');
lbc = load('lb_exp3.mat');
true_K = [7,2,7,4,9,6,6,6];

for i = 1:length(models)
    m = models{i}; for s = 1:length(data); data(s).m = m; data(s).true_K = true_K(i); end
    a = 2; b = 2; % beta prior
    minlr = 0.01;
    maxlr = 0.99;
    clear param
    disp(['Now fitting...' models{i}])
    if contains(m, 'rlwm')
        param(1) = struct('name','beta1','lb',1,'ub',50,'logpdf',@(x) 0,'label','\beta_{RL}');
        param(2) = struct('name','beta2','lb',1,'ub',50,'logpdf',@(x) 0,'label','\beta_{WM}');
        param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(4) = struct('name','phi','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\phi');
        param(5) = struct('name','C','lb',0,'ub',5,'logpdf',@(x) 0,'label','C');
        param(6) = struct('name','rho','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\rho');
        param(7) = struct('name','gamma','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\gamma');

    elseif contains(m, 'nocost')
        param(1) = struct('name','beta0','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta');
        param(2) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');

    elseif contains(m, 'nc_multibeta')
        param(1) = struct('name','beta11','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{11}');
        param(2) = struct('name','beta12','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{12}');
        param(3) = struct('name','beta21','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{21}');
        param(4) = struct('name','beta22','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{22}');
        param(5) = struct('name','beta31','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{31}');
        param(6) = struct('name','beta32','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{32}');
        param(7) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');

    elseif contains(m, 'fixed')
        param(1) = struct('name','beta0','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta');
        param(2) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(3) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
        param(4) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');

    elseif contains(m, 'f_multibeta')
        param(1) = struct('name','beta11','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{11}');
        param(2) = struct('name','beta12','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{12}');
        param(3) = struct('name','beta21','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{21}');
        param(4) = struct('name','beta22','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{22}');
        param(5) = struct('name','beta31','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{31}');
        param(6) = struct('name','beta32','lb',1,'ub',20,'logpdf',@(x) 0,'label','\beta_{32}');
        param(7) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(8) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
        param(9) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');

    elseif contains(m, 'capacity')
        param(1) = struct('name','C','lb',lb+0.01,'ub',2,'logpdf',@(x) 0,'label','C');
        param(2) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
        param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(4) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
        param(5) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
        param(6) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
        param(7) = struct('name','compress','lb',lbc.lb,'ub',2,'logpdf',@(x) 0,'label','C_{reduced}');

    elseif contains(m, 'value')
        param(1) = struct('name','V','lb',0.766,'ub',1,'logpdf',@(x) 0,'label','V');
        param(2) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
        param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(4) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
        param(5) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
        param(6) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');

    elseif contains(m, 'cv')
        param(1) = struct('name','C','lb',lb+0.01,'ub',2,'logpdf',@(x) 0,'label','C');
        param(2) = struct('name','V','lb',0.766,'ub',1,'logpdf',@(x) 0,'label','V');
        %param(2) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
        param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
        param(4) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
        param(5) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
        param(6) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
        param(7) = struct('name','compress','lb',lbc.lb,'ub',2,'logpdf',@(x) 0,'label','C_{reduced}');

    end
    if contains(m, 'rlwm')
        likfun = @actor_critic_lik_rlwm;
    else
        likfun = @actor_critic_lik;
    end
    %likfun = @actor_critic_lik_test;
    results(i) = mfit_optimize(likfun,param,data);
end

bms_results = mfit_bms(results,1);

if save_mat
    save('models.mat','results','bms_results'); % 8 non-reduced models
end
end