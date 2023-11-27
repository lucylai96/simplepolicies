function [lik,latents] = actor_critic_lik_rt_rlwm(x,DATA)

% Fit actor-critic agent model to data
%
% USAGE: simdata = actor_critic_lik(x,data)

% fixed
agent.t0 = 150;
agent.sv = 0.1;

% assign fitted parameters
agent.beta1 = 50;
agent.beta2 = 50;
agent.lrate_theta = x(1);
agent.phi  = x(2);
agent.C = x(3);
agent.rho = x(4);
agent.gamma = x(5);
agent.A = x(6);
agent.b_A = x(7);
agent.b2_A = x(8);
agent.eta = x(9);

agent.b = agent.A + agent.b_A;
agent.b2 = agent.A + agent.b2_A;

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
        rt = data.rt(ix);

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
                POLICY(t,:) = [NaN NaN NaN];
                ENTROPY(t,:) = NaN;
                rt(t) = NaN;
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

            % compute prior
            d = beta_rl.*theta; logpolicy_full_rl = d - logsumexp(d,2); policy_full_rl = exp(logpolicy_full_rl);
            d = beta_wm.*qwm; logpolicy_full_wm = d - logsumexp(d,2); policy_full_wm = exp(logpolicy_full_wm);
            policy_full = (1-w).*policy_full_rl + w.*policy_full_wm;
            prior = mean(policy_full);

            POLICY(t,:) = policy;
            ENTROPY(t,:) = -nansum(prior.*log2(prior));

            if r == 1 % pos rpe
                theta(s,a) = theta(s,a) + agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + 1*(r - qwm(s,a));
            else      % neg rpe
                theta(s,a) = theta(s,a) + agent.gamma*agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + agent.gamma*1*(r - qwm(s,a));
            end

            qwm = qwm + agent.phi*(w0 - qwm);  % decay

            w = agent.rho * min(1,agent.C/setsize);

            if nargout > 1
                latents.lik(eix) = latents.lik(eix)+logpolicy(a);
            end
        end

        %% likelihood function of LBA
        RT = rt - agent.t0;                               % subract non-decision time
        v = agent.eta.*(POLICY./ENTROPY);                 % drift rates
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