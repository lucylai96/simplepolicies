function [lik, latents] = actor_critic_lik_rt(x,DATA)

% Fit actor-critic agent model to data
%
% USAGE: simdata = actor_critic_lik(x,data)

agent.policy_update = DATA.m;

% fixed
agent.lrate_r = 0.01;
agent.lrate_e = 0.01;
agent.t0 = 150;
agent.beta0 = 1;
agent.sigma = 1;
agent.cost = 1;
agent.lrate_beta = 0;

if contains(agent.policy_update, 'fixed')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_p = x(4);
    agent.compress = x(5);
    agent.b1 = x(6);
    agent.b2 = x(7);

elseif contains(agent.policy_update, 'f_multibeta')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(7);
    agent.lrate_V = x(8);
    agent.lrate_p = x(9);
    agent.b1 = x(10);
    agent.b2 = x(11);

elseif contains(agent.policy_update, 'capacity')
    agent.C = x(1);
    agent.V = [];
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = x(6);
    agent.compress = x(7);
    agent.b1 = x(8);
    agent.b2 = x(9);

elseif contains(agent.policy_update, 'value')
    agent.C = [];
    agent.V = x(1);
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = x(6);
    agent.compress = x(7);
    agent.b1 = x(8);
    agent.b2 = x(9);

elseif contains(agent.policy_update, 'cv')
    agent.C = x(1);
    agent.V = x(2);
    agent.beta0 = x(3);
    agent.lrate_theta = x(4);
    agent.lrate_V = x(5);
    agent.lrate_beta = x(6);
    agent.lrate_p = x(7);
    agent.compress = x(8);
    agent.b1 = x(9);
    agent.b2 = x(10);

elseif contains(agent.policy_update, 'capacity_pg')
    agent.C = x(1);
    agent.V = [];
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = x(6);
    agent.compress = x(7);
    agent.b1 = x(8);
    agent.b2 = x(9);

elseif contains(agent.policy_update, 'value_pg')
    agent.C = [];
    agent.V = x(1);
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = x(6);
    agent.compress = x(7);
    agent.b1 = x(8);
    agent.b2 = x(9);

elseif contains(agent.policy_update, 'pg')
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_beta = x(4);
    agent.lrate_p = x(5);
    agent.compress = x(6);
    agent.b1 = x(7);
    agent.b2 = x(8);
end % assign parameters

lik = 0; latents.lik = zeros(1,length(DATA.exp)); k = 1;
exps = [1 2 3];
for eix = exps
    data = DATA.exp(eix);
    C = unique(data.cond);
    lik_rt = zeros(length(C),sum(data.cond==1));
    lik_choice = 0;

    for c = 1:length(C)
        if eix == 3 && c == 2 && isfield(agent,'compress') && contains(agent.policy_update,'c')
            agent.C = agent.compress;
            agent.lrate_p = agent.lrate_p + 0.1;
            if  agent.lrate_p >1
                agent.lrate_p = 0.99;
            end
        elseif  eix == 3 && c == 2 && isfield(agent,'compress') && contains(agent.policy_update,'value')
            agent.V = agent.compress;
            agent.lrate_p = agent.lrate_p + 0.1;
            if  agent.lrate_p >1
                agent.lrate_p = 0.99;
            end

        elseif eix == 3 && c ==2 && (contains(agent.policy_update,'fixed') || contains(agent.policy_update,'pg'))
            agent.beta0 = agent.compress;
            agent.lrate_p = agent.lrate_p + 0.1;
        end

        ix = find(data.cond==C(c));
        state = data.s(ix);
        action = data.a(ix);
        reward = data.r(ix);
        rt = data.rt(ix);

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

        for t = 1:length(state)
            s = state(t); a = action(t); r = reward(t);

            if isnan(a) || a<1 || rt(t)<5
                continue; % skip over non-responses
            end

            d = beta*theta(s,:) + log(p);

            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);               % softmax policy
            entropy = -nansum(policy.*log2(policy));

            if logpolicy(a)<-10
                logpolicy(a) = -10;
            end

            lik_choice = lik_choice + logpolicy(a);

            cost = logpolicy(a) - log(p(a));       % policy complexity cost
            rpe = beta*r - cost - V(s);            % reward prediction error

            lik_rt(c,t) = (log(rt(t)) - log(agent.t0 + agent.b1*abs(cost) + agent.b2*entropy))^2;

            rho = rho + agent.lrate_r*(r-rho);             % avg reward update
            ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update

            chosen = a; idxs = 1:nA; unchosen = idxs(idxs~=chosen);
            g(:,chosen) = beta*(1-policy(chosen));     % policy gradient for chosen actions
            g(:,unchosen) = beta*(-policy(unchosen));  % policy gradient for unchosen actions
            theta(s,:) = theta(s,:) + agent.lrate_theta*rpe*g;  % policy parameter update
            V(s) = V(s) + agent.lrate_V*rpe;

            if agent.lrate_beta > 0
                switch agent.policy_update
                    case 'capacity'
                        beta = beta + agent.lrate_beta*(agent.C-ecost);
                    case 'value'
                        beta = beta + agent.lrate_beta*(agent.V-rho);
                    case 'cv'
                        beta = beta + agent.lrate_beta*((agent.C-ecost)/(agent.V-rho)-beta);
                    case 'pg'
                        beta = beta + agent.lrate_beta*rpe*(theta(s,a)-(theta(s,:)*policy'));
                    case 'capacity_pg'
                        beta = beta + agent.lrate_beta*(agent.C-ecost)*(theta(s,a)-(theta(s,:)*policy'));
                    case 'value_pg'
                        beta = beta + agent.lrate_beta*(agent.V-rho)*(theta(s,a)-(theta(s,:)*policy'));
                end
                beta = max(min(beta,30),0.1);
            end

            if agent.lrate_p > 0
                p = p + agent.lrate_p*(policy - p); p = p./sum(p); % marginal update
            end

        end
        n(c) = length(state);
    end % each condition

    lik_rt(lik_rt<-10) = -10;
    lik_rt(lik_rt>1e5) = 1e5;
    lik = lik + lik_choice + sum(n)*log(1/(sqrt(2*pi)*agent.sigma))-(1/(2*agent.sigma^2))*sum(lik_rt(:));
    latents.lik(eix) = latents.lik(eix) + lik_choice + sum(n)*log(1/(sqrt(2*pi)*agent.sigma))-(1/(2*agent.sigma^2))*sum(lik_rt(:));

end % each experiment

end % function