function simdata = sim_fitted(model, data, results)

%{
    Simulate the agent with the fitted model parameter for the set size
    manipulation experiment.

    USAGE: simdata = sim_fitted()
%}

prettyplot
if length(results)>1
    models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};
    %models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv','capacity_pg','value_pg','pg'};

    idx = find(strcmpi(model,models)==1);
    results = results(idx);
end

for s = 1:length(data)
    agent.policy_update = model;
    agent.t0 = 150; % fixed across all models
    agent.lrate_beta = 0;
    agent.compress = [];

    for k = 1:length(results.param)
        agent.(results.param(k).name) = results.x(s,k);
    end

    if contains(model,'n')
        % fixed parameters
        agent.b = agent.b_A+agent.A;
        agent.b2 = agent.b2_A+agent.A;
        agent.sv = 0.1;
        agent.eta = 1;

        simdata(s) = actor_critic_nc(agent, data(s));

    elseif contains(model,'rlwm')
        % fixed parameters
        agent.b = agent.b_A+agent.A;
        agent.b2 = agent.b2_A+agent.A;
        agent.sv = 0.1;
        agent.eta = 1;
        agent.beta_rl = 50;
        agent.beta_wm = 50;

        simdata(s) = actor_critic_rlwm(agent, data(s));

    else % all cost models
        % fixed parameters
        agent.lrate_r = 0.01;
        agent.lrate_e = 0.01;
        agent.sigma = 0.9;
        agent.V = 1;
        simdata(s) = actor_critic(agent, data(s));
    end
end
end

