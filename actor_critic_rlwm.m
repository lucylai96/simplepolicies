function simdata = actor_critic_rlwm(agent,DATA)

% Simulate RLWM (Collins & Frank) model

% USAGE: simdata = actor_critic_rlwm(x,data)

exps = [1 2 3];
for eix = exps
    data = DATA.exp(eix);
    C = unique(data.cond);

    for c = 1:length(C)
        ix = find(data.cond==C(c));
        state = data.s(ix);

        R = data.Q(:,:,ix(1));
        setsize = length(unique(state));   % number of distinct stimuli
        nA = size(R,2);                    % number of distinct actions
        theta = zeros(setsize,nA);         % policy parameters
        qwm = zeros(setsize,nA);           % WM component
        w0 = 1/nA;
        w = agent.rho * min(1,agent.C/setsize);

        for t = 1:length(state)
            s = state(t);

            % RL component
            d = agent.beta_rl*theta(s,:);
            logpolicy = d - logsumexp(d);
            policy_rl = exp(logpolicy);                    % softmax policy

            % WM component
            d = agent.beta_wm*qwm(s,:);
            logpolicy = d - logsumexp(d);
            policy_wm = exp(logpolicy);                    % softmax policy

            % combined policy
            policy = (1-w)*policy_rl + w*policy_wm;
           
            % compute prior & entropy
            d = agent.beta_rl.*theta; logpolicy_full_rl = d - logsumexp(d,2); policy_full_rl = exp(logpolicy_full_rl);
            d = agent.beta_wm.*qwm; logpolicy_full_wm = d - logsumexp(d,2); policy_full_wm = exp(logpolicy_full_wm);
            policy_full = (1-w).*policy_full_rl + w.*policy_full_wm;
            prior = mean(policy_full);
            entropy = -nansum(prior.*log2(prior));

            %a = fastrandsample(policy); % action
            %r = fastrandsample(R(s,a)); % reward
            
            % calculate RT
            v = agent.eta.*policy/entropy;
            rsp = agent.A.*rand(size(policy));    % generate random starting point from ~U[0,A]
            drift = abs(normrnd(v,agent.sv));     % generate drift rate from ~N[v,sv] (positive values only)
             if eix == 3 && c == 2
                 T = (agent.b2-rsp)./drift + agent.t0;  % generate time to threshold
            else
                 T = (agent.b-rsp)./drift + agent.t0;  % generate time to threshold
            end
            [~,a] = min(T);                       % select action
            rt = T(a);
            r = fastrandsample(R(s,a)); % reward

            if r == 1 % pos rpe
                theta(s,a) = theta(s,a) + agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + 1*(r - qwm(s,a));
            else      % neg rpe
                theta(s,a) = theta(s,a) + agent.gamma*agent.lrate_theta*(r - theta(s,a));
                qwm(s,a) = qwm(s,a) + agent.gamma*1*(r - qwm(s,a));
            end

            qwm = qwm + agent.phi*(1/nA - qwm);  % decay
            w = agent.rho * min(1,agent.C/setsize);

            simdata.exp(eix).s(ix(t),:) = s;
            simdata.exp(eix).a(ix(t),:) = a;
            simdata.exp(eix).r(ix(t),:) = r;
            simdata.exp(eix).cond(ix(t),:) = c;
            simdata.exp(eix).rt(ix(t),:) = rt;
            simdata.exp(eix).Q(:,:,ix(t)) = R;
        end
    end % each condition
end % each experiment
end % function