function results = analyze_data0(fig,data,bh,sidx)
% pilot 0
% data - the loaded mat file
% sidx - specific subject indices
% bh - only plot the end of the block for optimal comparison with blahut-arimoto simulations

if nargin <3; bh = 0; sidx = 1:length(data); end
if nargin <4; sidx = 1:length(data); end

DATA = data;
nSubj = length(data);
cmap = brewermap(3,'Set1');

policy_update = {'complexity_limit','value_absolute','value_percent'};
opt_labels = {'Optimize capacity','Optimize aspiration','Optimize value max'};
beta = linspace(0.01,30,70);
Q_labels = {'Q1','Q2','Q3'};
clear R V

switch fig
    case 'exp1'
        Ps = ones(1,3)/3;
        Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];    % 1 optimal action per state
            [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];     % 2 optimal actions per state
            [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};          % 2 optimal actions per state
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};
    case 'exp2'
        Ps = ones(1,3)/3;
        Q = {[0.7 0 0.8;0.7 0.8 0;0.7 0.8 0];    % a1 suboptimal for 3 states
            [0.5 0 1;1 0.5 0;0 1 0.5]};          % each state has its own suboptimal action
        sub = {[1 NaN NaN; 1 NaN NaN; 1 NaN NaN];
            [1 NaN NaN; NaN 1 NaN; NaN NaN 1]};
    case 'exp3'
        Ps = ones(1,4)/4;
        Q = {[0.8 0.2;0.8 0.2;0.2 0.8;0.2 0.8];    % 2 states with same optimal action
            [0.2 0.8;0.2 0.8;0.2 0.8;0.8 0.2]};    % 3 states with same optimal action
        sub = {[NaN NaN; NaN NaN; NaN NaN; 1 NaN];
            [NaN NaN; NaN NaN; NaN NaN; NaN 1]};

    case 'exp4'
        Ps = ones(1,3)/3;
        Q = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];    % 1 optimal action per state
            [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];     % 2 optimal actions per state
            [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};          % 2 optimal actions per state
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};
end % switch (which experiment)

%% plot
for i = 1:length(Q)
    [R(i,:),V(i,:),pa(:,:,i)] = blahut_arimoto(Ps,Q{i},beta); % R = policy complexity, V = average reward
end

figure; nexttile; hold on; colororder(cmap(1:length(Q),:))
plot(R',V');
ylabel('Average reward')
xlabel('Policy complexity')

eix = num2str(fig(end))-'0';

for s = 1:length(sidx)
    data = DATA(sidx(s)).exp(eix);
    C = unique(data.cond)';
    for c = C
        ix = find(data.cond==C(c));
        if bh
            ix = ix(end-29:end);
        end
        state = data.s(ix);
        action = data.a(ix);
        reward = data.r(ix);
        rt(s,c) = mean(data.rt(ix));

        R_data(s,c) = mutual_information(state, action ,0.1);
        V_data(s,c) = mean(reward);
        if isempty(find(R(c,:)>=R_data(s,c),1))
            beta_data(s,c) = beta(end);
        else
            beta_data(s,c) = beta(find(R(c,:)>=R_data(s,c),1));
        end

        win = 20; % groups of 20 trials
        for q = 1:length(state)-win
            R_data_mov(s,q,c) = mutual_information(state(q:q+win-1), action(q:q+win-1),0.1);
            V_data_mov(s,q,c) = mean(reward(q:q+win-1));
            if isempty(find(R(c,:)>=R_data_mov(s,q,c),1))
                beta_mov(s,q,c) =  beta(end);
            else
                beta_mov(s,q,c) =  beta(find(R(c,:)>=R_data_mov(s,q,c),1));
            end
        end

        for i = 1:max(state)
            ps(i)= sum(state==i);
        end
        ps = ps./sum(ps);
        for i = 1:max(state)
            for j = 1:max(action)
                pas(i,j) = sum(action(state==i)==j);
            end
        end
        pas = pas./sum(pas,2);

        stochasticity(s,c) = -ps*nansum(pas.*log2(pas),2);
        temp = pas.*sub{c};
        suboptimal(s,c) = nanmean(temp(:));
    end
end
hold on; colororder(cmap(1:length(Q),:)); plot(R_data,V_data,'.','MarkerSize',20)
for i = 1:length(Q)
    plot(mean(R_data(:,i)),mean(V_data(:,i)),'o','MarkerSize',20,'MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','k')
end
ylim([0 1]); xlim([0 1.2])
legend(Q_labels(1:length(Q)), 'location','Southeast')

% avg complexity
nexttile; hold on;colororder(cmap(1:length(Q),:));
b = barwitherr(sem(R_data,1),mean(R_data));
ylabel('policy complexity'); set(gca,'XTick',[]); ylim([0 1])
xticks([b.XEndPoints]); xticklabels(Q_labels)

% avg reward
nexttile; hold on;
b = barwitherr(sem(V_data,1),mean(V_data));
ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
xticks([b.XEndPoints]); xticklabels(Q_labels)

% stochasticity
nexttile; hold on;
barwitherr(sem(stochasticity,1),mean(stochasticity))
ylabel('stochasticity H(A|S)'); set(gca,'XTick',[]); ylim([0 2])
xticks([b.XEndPoints]); xticklabels(Q_labels)

% suboptimal actions
nexttile; hold on; colororder(cmap(1:length(Q),:))
barwitherr(sem(suboptimal,1),mean(suboptimal))
ylabel('p(suboptimal actions)'); set(gca,'XTick',[])
xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([0 1])

% RT
nexttile; hold on; colororder(cmap(1:length(Q),:))
barwitherr(sem(rt,1),mean(rt))
ylabel('RT (ms)'); set(gca,'XTick',[])
xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([0 1500])

% beta vs policy complexity
nexttile; hold on;
plot(R',beta)
m = mean(R_data);
for c = 1:length(Q)
    ix = find(R(c,:)>=m(c),1); % find closest theoretical complexity value match
    if isempty(ix)
        plot(R(c,end),10,'.','MarkerSize',40)
    else
        plot(R(c,ix),beta(ix),'.','MarkerSize',40)
    end
end
%plot(mean(R_data),mean(beta_data),'.','MarkerSize',40)
ylabel('\beta'); xlabel('policy complexity')
ylim([0 10]);

sgtitle(fig,'FontSize',25)

set(gcf, 'Position',  [0, 100, 1500, 250])

% moving complexity and reward
figure; hold on;
nexttile; hold on
for c = 1:length(Q)
    shadedErrorBar([],mean(R_data_mov(:,:,c)),sem(R_data_mov(:,:,c),1),{'Color',cmap(c,:)},1)
end
ylabel('Policy complexity'); xlabel('Trials'); ylim([ 0 1])
nexttile; hold on
for c = 1:length(Q)
    shadedErrorBar([],mean(V_data_mov(:,:,c)),sem(V_data_mov(:,:,c),1),{'Color',cmap(c,:)},1)
end
ylabel('Average reward'); xlabel('Trials'); ylim([ 0 1])

% nexttile; hold on
% for c = 1:length(Q)
%     shadedErrorBar([],mean(beta_mov(:,:,c)),sem(beta_mov(:,:,c),1),{'Color',cmap(c,:)},1)
% end
% ylabel('Estimated \beta'); xlabel('Trials');ylim([0 max(mean(beta_data))+10])


nexttile; hold on; colororder(cmap(1:length(Q),:))
for c = 1:length(Q)
    plot(mean(R_data_mov(:,:,c)),mean(V_data_mov(:,:,c)),'-o')
end
plot(R',V')
ylabel('Average reward'); xlabel('Policy complexity');

set(gcf, 'Position',  [0, 100, 800, 250])


results.R_data = R_data;
results.V_data = V_data;
results.stochasticity = stochasticity;
results.suboptimal = suboptimal;

end