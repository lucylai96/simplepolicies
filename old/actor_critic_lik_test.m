function [lik,latents] = actor_critic_lik_test(x,DATA)

% Fit actor-critic agent model to data
%
% USAGE: simdata = actor_critic_lik(x,data)

agent.policy_update = DATA.m;

% fixed
agent.lrate_p = 0;
agent.lrate_r = 0.01;
agent.lrate_e = 0.01;
agent.lrate_beta = 0.1;
agent.lrate_V = 0;

agent.t0 = 200;
agent.beta0 = 1;
agent.cost = 1;

if contains(agent.policy_update, 'nocost')
    agent.cost = 0;
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_beta = 0;

elseif contains(agent.policy_update, 'nc_multibeta')
    agent.cost = 0;
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_beta = 0;

elseif contains(agent.policy_update, 'fixed')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_p = x(4);
    agent.lrate_beta = 0;

elseif contains(agent.policy_update, 'f_multibeta')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_p = x(5);
    agent.lrate_beta = 0;

elseif contains(agent.policy_update, 'capacity')
    agent.C = x(1);
    agent.V = [];
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    %agent.compress = x(5);
    agent.lrate_p = x(5);

elseif contains(agent.policy_update, 'value')
    agent.C = [];
    agent.V = x(1);
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_p = x(5);

elseif contains(agent.policy_update, 'cv')
    agent.C = x(1);
    agent.V = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    %agent.compress = x(5);
    agent.beta0 = 1;
    agent.lrate_p = x(5);
end % assign parameters

lik = 0; latents.lik = zeros(1,length(DATA.exp)); k = 1;
exps = [1 2 3];
exps = 1;
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
        V = zeros(setsize,1);              % state values
        theta = zeros(setsize,nA);         % policy parameters
        beta = agent.beta0;

        if contains(agent.policy_update,'multibeta')
            beta = x(k);
            k = k+1;
        end

        p = ones(1,nA)/nA;
        ecost = mutual_information(state(1:10),action(1:10),0.1);
        rho = mean(R(:));

        if contains(agent.policy_update, 'cv')
            beta = (agent.C-ecost)/(agent.V-rho);
        end

        for t = 1:length(state)
            s = state(t); a = action(t); r = reward(t);

            if isnan(a) || a<1
                continue; % skip over non-responses
            end
            if agent.cost == 1
                d = beta*theta(s,:) + log(p);
            else
                d = beta*theta(s,:);
            end

            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);                    % softmax policy
            if logpolicy(a)<-10
                logpolicy(a) = -10;
            end
            lik = lik + logpolicy(a);
            cost = abs(logpolicy(a) - log(p(a)));       % policy complexity cost

            if agent.cost == 1                     % if it's a cost model
                rpe = beta*r - cost - V(s);        % reward prediction error
            else
                rpe = r - theta(s,a);                    % reward prediction error w/o cost
            end

            rho = rho + agent.lrate_r*(r-rho);             % avg reward update
            ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update

            if agent.cost == 1
                chosen = a; idxs = 1:nA; unchosen = idxs(idxs~=chosen);
                g(:,chosen) = beta*(1-policy(chosen));              % policy gradient for chosen actions
                g(:,unchosen) = beta*(-policy(unchosen));           % policy gradient for unchosen actions
                theta(s,:) = theta(s,:) + agent.lrate_theta*rpe*g;  % policy parameter update
                V(s) = V(s) + agent.lrate_V*rpe;
            else
                theta(s,a) = theta(s,a) + agent.lrate_theta*rpe;
            end

            if agent.lrate_beta > 0
                switch agent.policy_update
                    case 'capacity'
                        beta = beta + agent.lrate_beta*(agent.C-ecost);
                    case 'value'
                        beta = beta + agent.lrate_beta*(agent.V-rho);
                    case 'cv'
                        beta = beta + agent.lrate_beta*((agent.C-ecost)/(agent.V-rho)-beta);
                end
                beta = max(min(beta,30),0);
            end
            if agent.lrate_p > 0
                p = p + agent.lrate_p*(policy - p); p = p./sum(p); % marginal update
            end

            if nargout > 1
                latents.lik(eix) = latents.lik(eix)+logpolicy(a);
            end
        end

    end % each condition
end % each experiment
end % function