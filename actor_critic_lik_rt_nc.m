function [lik, latents] = actor_critic_lik_rt_nc(x,DATA)

% Fit actor-critic agent model to data
%
% USAGE: simdata = actor_critic_lik(x,data)

agent.policy_update = DATA.m;

% fixed
agent.t0 = 150;
agent.sv = 0.1;

% assign fitted parameters
if contains(agent.policy_update, 'nocost')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.A = x(3);
    agent.b_A = x(4);
    agent.b2_A = x(5);
    agent.eta = x(6);
    agent.b = agent.b_A+agent.A;
    agent.b2 = agent.b2_A+agent.A;

elseif contains(agent.policy_update, 'nc_multibeta')
    agent.C = [];
    agent.V = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(7);
    agent.A = x(8);
    agent.b_A = x(9);
    agent.b2_A = x(10);
    agent.eta = x(11);
    agent.b = agent.b_A+agent.A;
    agent.b2 = agent.b2_A+agent.A;
end % assign parameters


lik = 0; latents.lik = zeros(1,length(DATA.exp)); k = 1;

for eix = 1:length(DATA.exp)
    data = DATA.exp(eix);

    C = unique(data.cond);
    for c = 1:length(C)
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

        for t = 1:length(state)
            s = state(t); a = action(t); r = reward(t);

            if isnan(a) || a<1
                POLICY(t,:) = [NaN NaN NaN];
                ENTROPY(t,:) = NaN;
                rt(t) = NaN;
                continue; % skip over non-responses
            end

            % compute prior
            d = beta.*theta;
            logpolicy_full = d - logsumexp(d,2);
            policy_full = exp(logpolicy_full);
            prior = mean(policy_full);

            % compute policy
            d = beta*theta(s,:);
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);               % softmax policy

            POLICY(t,:) = policy;
            ENTROPY(t,:) = -nansum(prior.*log2(prior));

            rpe = r - V(s);                    % reward prediction error w/o cost
            theta(s,a) = theta(s,a) + agent.lrate_theta*rpe;  % policy parameter update

        end

        %% likelihood function of LBA
        RT = rt - agent.t0;                           % subract non-decision time
        v = agent.eta.*(POLICY./ENTROPY);             % drift rates
        if eix == 3 && c == 2
            pdf = LBA(RT, agent.A, agent.b2, v, agent.sv); % get likelihood of RT
        else
            pdf = LBA(RT, agent.A, agent.b, v, agent.sv); % get likelihood of RT
        end
        pdf(pdf<=1e-5) = 1e-5;                        % avoid 0s or negatives
        lik = lik + nansum(log(pdf));                 % build likelihood function
        clear v POLICY ENTROPY

        latents.lik(eix) = latents.lik(eix) + nansum(log(pdf));
    end % each condition
end % each experiment
end % function