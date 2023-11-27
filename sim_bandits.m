function simdata = sim_bandits(data,policy_update,agent)

% this is to simulate manually (before data had been collected) 

% agent.lrate_theta = 0.8;
% agent.lrate_V = 0.5;
% agent.lrate_beta = 0.5;
% agent.lrate_e = 0.5;
% agent.lrate_r = 0.5;
% agent.lrate_p = 0.5;
% agent.beta0 = 0.5;
% agent.policy_update = policy_update;
% agent.C = 1;
% agent.V = 1;% percentage
%simdata = actor_critic(agent,data);

agent.C = 1; 
agent.V = 1;
agent.lrate_theta = 0.2;
agent.lrate_V = 0.1;
agent.lrate_p = 0.01;
agent.lrate_r = 0.01;
agent.lrate_e = 0.01;
agent.lrate_beta = 0.5;
agent.compress = 0.4;
agent.beta0 = 1;
agent.cost = 1;

agent.t0 = 200;
agent.sigma = 20;
agent.b1 = 500;
agent.b2 = 400;

agent.policy_update = policy_update;
simdata = actor_critic(agent,data);

end 