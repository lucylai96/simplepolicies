function simdata = actor_critic_old(agent,DATA)

% Simulate actor-critic agent.
%
% USAGE: simdata = actor_critic(agent,data)

if ~isfield(agent,'beta')
    agent.beta = agent.beta0;
end
if contains(agent.policy_update,'multibeta')
    k = 1;
    x = [agent.beta11 agent.beta12 agent.beta21 agent.beta22 agent.beta31 agent.beta32];
end
gradient = NaN; dB = NaN;
for eix = 1:length(DATA.exp)
    data = DATA.exp(eix);
    C = unique(data.cond);
    if eix == 3 && isfield(agent,'compress')
        agent.C = agent.compress;
        agent.V = agent.compress;
    end
    for c = 1:length(C)
        ix = find(data.cond==C(c));
        state = data.s(ix);
        if isfield(data,'a')
            action = data.a(ix);
            reward = data.r(ix);
        end
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
        ecost0 = 0; rho0 = 0;
        ecost = 0;
        if isfield(data,'a')
            ecost = mutual_information(state(1:10),action(1:10),0.1);
        end
        ecost = 0;
        rho = mean(R(:));
        if contains(agent.policy_update, 'cv')
            beta = (agent.C-ecost)/(agent.V-rho);
        end

        for t = 1:length(state)
            s = state(t);
            if agent.cost == 1
                d = beta*theta(s,:) + log(p);
            else
                d = beta*theta(s,:);
            end
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);    % softmax policy
            a = fastrandsample(policy); % action
            r = fastrandsample(R(s,a)); % reward

            cost = logpolicy(a) - log(p(a));          % policy complexity cost

            if agent.cost == 1                      % if it's a cost model
                rpe = beta*r - cost - V(s);        % reward prediction error
            else
                rpe = r - V(s);                    % reward prediction error w/o cost
            end
            rt = agent.t0+agent.b1*abs(cost)+normrnd(0,agent.sigma);

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
                        gradient = agent.C-ecost; dB = NaN;
                    case 'value'
                        beta = beta + agent.lrate_beta*(agent.V-rho);
                        %beta = beta + agent.lrate_beta*(agent.betastar(c)-beta);
                        gradient = agent.V-rho;
                        dB = NaN;
                    case 'cv'
                        beta = beta + agent.lrate_beta*((agent.C-ecost)/(agent.V-rho) - beta);
                        %beta = (agent.C-ecost)/(agent.V-rho);
                        gradient = agent.V-rho;
                        dB = NaN;
                    case 'value_percent'
                        target_V = agent.V*max(R(:));
                        beta = beta + agent.lrate_beta*(target_V-rho);
                        gradient = target_V-rho; dB = NaN;
                    case 'value_gradient'
                        if abs(beta0-beta)>0.01 % only assign beta0 if beta changed
                            dV = rho-rho0;
                            dB = beta-beta0;
                            gradient = dV/dB;
                            beta0 = beta;
                            beta = beta + (dV/dB)*2*(agent.V-rho);
                        else
                            gradient = NaN;
                        end

                    case 'complexity_gradient'
                        if abs(beta0-beta)>0.01 % only assign beta0 if beta changed
                            dR = ecost-ecost0;
                            dB = beta-beta0;
                            gradient = dR/dB;

                            beta0 = beta;
                            beta = beta + (dR/dB)*(agent.C-ecost);
                        else
                            gradient = NaN;
                        end
                end
                beta = max(min(beta,30),0);
                rho0 = rho;
                ecost0 = ecost;
            end

            if agent.lrate_p > 0
                p = p + agent.lrate_p*(policy - p); p = p./sum(p); % marginal update
            end

            simdata.exp(eix).s(ix(t),:) = s;
            simdata.exp(eix).a(ix(t),:) = a;
            simdata.exp(eix).r(ix(t),:) = r;
            simdata.exp(eix).cond(ix(t),:) = c;
            simdata.exp(eix).beta(ix(t),:) = beta;
            simdata.exp(eix).ecost(ix(t),:) = ecost;
            simdata.exp(eix).cost(ix(t),:) = cost;
            simdata.exp(eix).rt(ix(t),:) = rt;
            simdata.exp(eix).Q(:,:,ix(t)) = R;
        end % for each timestep
        simdata.exp(eix).N = length(state)*2;
    end % for each condition
end % for each experiment
end % function