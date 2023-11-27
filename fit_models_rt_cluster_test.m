function [results] = fit_models_rt_cluster_test(m)
%{
    Fit data to the models you specify.
%}

load lb.mat
load data.mat

models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};

for s = 1:length(data); data(s).m = m; end
a = 2; b = 2; % beta prior
minlr = 0.01; maxlr = 0.99;

clear param
disp(['Now fitting...' m])
if contains(m, 'rlwm')
    %param(1) = struct('name','beta1','lb',1,'ub',100,'logpdf',@(x) 0,'label','\beta_{RL}');
    %param(2) = struct('name','beta2','lb',1,'ub',100,'logpdf',@(x) 0,'label','\beta_{WM}');
    param(1) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(2) = struct('name','phi','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\phi');
    param(3) = struct('name','C','lb',0,'ub',5,'logpdf',@(x) 0,'label','C');
    param(4) = struct('name','rho','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\rho');
    param(5) = struct('name','gamma','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\gamma');
    param(6) = struct('name','A','logpdf',@(x) 0,'lb',1,'ub',500,'label','A');
    param(7) = struct('name','b_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound-A');
    param(8) = struct('name','b2_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound2-A');
    param(9) = struct('name','eta','logpdf',@(x) 0,'lb',0,'ub',3,'label','\eta');
    param(10) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'nocost')
    param(1) = struct('name','beta0','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta');
    param(2) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(3) = struct('name','A','logpdf',@(x) 0,'lb',1,'ub',500,'label','A');
    param(4) = struct('name','b_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound-A');
    param(5) = struct('name','b2_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound2-A'); 
    param(6) = struct('name','eta','logpdf',@(x) 0,'lb',0,'ub',3,'label','\eta');
    param(7) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');
    

elseif contains(m, 'nc_multibeta')
    param(1) = struct('name','beta11','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{11}');
    param(2) = struct('name','beta12','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{12}');
    param(3) = struct('name','beta21','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{21}');
    param(4) = struct('name','beta22','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{22}');
    param(5) = struct('name','beta31','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{31}');
    param(6) = struct('name','beta32','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{32}');
    param(7) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(8) = struct('name','A','logpdf',@(x) 0,'lb',1,'ub',500,'label','A');
    param(9) = struct('name','b_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound-A');
    param(10) = struct('name','b2_A','logpdf',@(x) 0,'lb',1,'ub',500,'label','bound2-A');
    param(11) = struct('name','eta','logpdf',@(x) 0,'lb',0,'ub',3,'label','\eta');
    param(12) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'fixed')
    param(1) = struct('name','beta0','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta');
    param(2) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(3) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
    param(4) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
    param(5) = struct('name','b1','lb',1,'ub',500,'logpdf',@(x) 0,'label','b1');
    param(6) = struct('name','b2','lb',1,'ub',500,'logpdf',@(x) 0,'label','b2');
    param(7) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'f_multibeta')
    param(1) = struct('name','beta11','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{11}');
    param(2) = struct('name','beta12','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{12}');
    param(3) = struct('name','beta21','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{21}');
    param(4) = struct('name','beta22','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{22}');
    param(5) = struct('name','beta31','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{31}');
    param(6) = struct('name','beta32','lb',1,'ub',30,'logpdf',@(x) 0,'label','\beta_{32}');
    param(7) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(8) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
    param(9) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
    param(10) = struct('name','b1','lb',1,'ub',500,'logpdf',@(x) 0,'label','b1');
    param(11) = struct('name','b2','lb',1,'ub',500,'logpdf',@(x) 0,'label','b2');
    param(12) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'capacity')
    param(1) = struct('name','C','lb',lb,'ub',3,'logpdf',@(x) 0,'label','C');
    param(2) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
    param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(4) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
    param(5) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
    param(6) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
    param(7) = struct('name','compress','lb',0,'ub',lb,'logpdf',@(x) 0,'label','C_{reduced}');
    param(8) = struct('name','b1','lb',1,'ub',500,'logpdf',@(x) 0,'label','b1');
    param(9) = struct('name','b2','lb',1,'ub',500,'logpdf',@(x) 0,'label','b2');
    param(10) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'value')
    param(1) = struct('name','V','lb',0,'ub',1,'logpdf',@(x) 0,'label','V');
    param(2) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
    param(3) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(4) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
    param(5) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
    param(6) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
    param(7) = struct('name','compress','lb',0,'ub',1,'logpdf',@(x) 0,'label','V_{reduced}');
    param(8) = struct('name','b1','lb',1,'ub',500,'logpdf',@(x) 0,'label','b1');
    param(9) = struct('name','b2','lb',1,'ub',500,'logpdf',@(x) 0,'label','b2');
    param(10) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');

elseif contains(m, 'cv')
    param(1) = struct('name','C','lb',lb,'ub',3,'logpdf',@(x) 0,'label','C');
    param(2) = struct('name','V','lb',0,'ub',1,'logpdf',@(x) 0,'label','V');
    param(3) = struct('name','beta0','lb',1,'ub',10,'logpdf',@(x) 0,'label','\beta0');
    param(4) = struct('name','lrate_theta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_{\theta}');
    param(5) = struct('name','lrate_V','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_V');
    param(6) = struct('name','lrate_beta','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_\beta');
    param(7) = struct('name','lrate_p','lb',minlr,'ub',maxlr,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','\alpha_p');
    param(8) = struct('name','compress','lb',0,'ub',lb,'logpdf',@(x) 0,'label','C_{reduced}');
    param(9) = struct('name','b1','lb',1,'ub',500,'logpdf',@(x) 0,'label','b1');
    param(10) = struct('name','b2','lb',1,'ub',500,'logpdf',@(x) 0,'label','b2');
    param(11) = struct('name','t0','logpdf',@(x) 0,'lb',1,'ub',250,'label','t_0');
end

if contains(m,'rlwm')
    likfun = @actor_critic_lik_rt_rlwm;
elseif contains(m,'n')
    likfun = @actor_critic_lik_rt_nc;
else
    likfun = @actor_critic_lik_rt;
end
results = mfit_optimize(likfun,param,data);

save(['test_' m '.mat'],'results')
end