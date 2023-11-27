function [lik,latents] = actor_critic_lik_rlwm(x,DATA)

% Fit actor-critic agent model to data
%
% USAGE: simdata = actor_critic_lik(x,data)

agent.policy_update = DATA.m;

% fixed
agent.t0 = 200;

% assign fitted parameters
agent.beta1 = x(1);
agent.beta2 = x(2);
agent.lrate_theta = x(3);
agent.phi  = x(4);
agent.C = x(5);
agent.rho = x(6);
agent.gamma = x(7);

lik = 0; latents.lik = zeros(1,length(DATA.exp)); k = 1;

exps = [1 2 3];
for eix = exps
    data = DATA.exp(eix);
    C = unique(data.cond);

    for c = 1:length(C)
        ix = find(data.cond==C(c));
        state = data.s(ix);
        action = data.a(ix);
        reward = data.r(ix);

        R = data.Q(:,:,ix(1));
        setsize = length(unique(state));   % number of distinct stimuli
        nA = size(R,2);                    % number of distinct actions
        theta = zeros(setsize,nA);         % policy parameters
        qwm = zeros(setsize,nA);           % WM component
        beta_rl = agent.beta1;
        beta_wm = agent.beta2;
        w0 = 1/nA;
        w = agent.rho * min(1,agent.C/setsize);

        for t = 1:length(state)
            s = state(t); a = action(t); r = reward(t);

            if isnan(a) || a<1
                continue; % skip over non-responses
            end

            % RL component
            d = beta_rl*theta(s,:);
            logpolicy = d - logsumexp(d);
            policy_rl = exp(logpolicy);                    % softmax policy

            % WM component
            d = beta_wm*qwm(s,:);
            logpolicy = d - logsumexp(d);
            policy_wm = exp(logpolicy);                    % softmax policy

            % combined policy
            policy = (1-w)*policy_rl + w*policy_wm;
            logpolicy = log(policy);

            if logpolicy(a)<-10
                logpolicy(a) = -10;
            end

            lik = lik + logpolicy(a);

            if r == 1 % pos rpe
                theta(s,a) = theta(s,a) + agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + 1*(r - qwm(s,a));
            else      % neg rpe
                theta(s,a) = theta(s,a) + agent.gamma*agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + agent.gamma*1*(r - qwm(s,a));
            end

            qwm = qwm + agent.phi*(1/nA - qwm);  % decay

            w = agent.rho * min(1,agent.C/setsize);

            if nargout > 1
                latents.lik(eix) = latents.lik(eix)+logpolicy(a);
            end
        end

    end % each condition
end % each experiment
end % function