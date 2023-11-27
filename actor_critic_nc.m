function simdata = actor_critic_nc(agent,DATA)

% Simulate actor-critic agent.
%
% USAGE: simdata = actor_critic(agent,data)

if contains(agent.policy_update,'multibeta')
    k = 1;
    x = [agent.beta11 agent.beta12 agent.beta21 agent.beta22 agent.beta31 agent.beta32];
end

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

        
        if contains(agent.policy_update,'multibeta')
            beta = x(k);
            k = k+1;
        else
            beta = agent.beta0;
        end

        for t = 1:length(state)
            s = state(t);
            d = beta*theta(s,:);
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);    % softmax policy

            % compute prior & entropy
            d = beta.*theta;
            logpolicy_full = d - logsumexp(d,2); 
            policy_full = exp(logpolicy_full);
            prior = mean(policy_full);
            entropy = -nansum(prior.*log2(prior));

            % calculate RT
            v = agent.eta.*policy/entropy;
            rsp = agent.A.*rand(size(policy));    % generate random starting point from ~U[0,A]
            drift = abs(normrnd(v,agent.sv));     % generate drift rate from ~N[v,sv] (positive values only)
            if eix == 3 && c == 2
                T = (agent.b2-rsp)./drift + agent.t0;  % generate time to threshold
            else
                T = (agent.b-rsp)./drift + agent.t0;   % generate time to threshold
            end
            [~,a] = min(T);                       % select action
            rt = T(a);
            
            r = fastrandsample(R(s,a));              % reward
            rpe = r - theta(s,a);                    % reward prediction error w/o cost

            theta(s,a) = theta(s,a) + agent.lrate_theta*rpe;

            simdata.exp(eix).s(ix(t),:) = s;
            simdata.exp(eix).a(ix(t),:) = a;
            simdata.exp(eix).r(ix(t),:) = r;
            simdata.exp(eix).cond(ix(t),:) = c;
            simdata.exp(eix).beta(ix(t),:) = beta;
            simdata.exp(eix).rt(ix(t),:) = rt;
            simdata.exp(eix).Q(:,:,ix(t)) = R;
        end % for each timestep
        simdata.exp(eix).N = length(state)*2;
    end % for each condition
end % for each experiment
end % function