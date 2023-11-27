function plot_data(fig, DATA, bh)
cmap = brewermap(3,'Set1');
Q_labels = {'Q1','Q2','Q3'};
beta = linspace(0,30,30);
switch fig
    case 'exp1'
        ps = ones(1,3)/3;
        Q = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]
            [1 1 0;0 1 1;1 0 1]};
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};

    case 'exp2'
        ps = ones(1,3)/3;
        Q = {[1 0.5 0;0 1 0.5;0.5 0 1];        % each state has its own optimal action
            [1 0.5 0;1 0 0.5;0.5 0 1]};         % 2 states with same optimal action
        sub = { [NaN 1 NaN; NaN NaN 1; 1 NaN NaN];
            [NaN 1 NaN; NaN NaN 1; 1 NaN NaN]};

    case 'exp3'
        ps = ones(1,3)/3;
        Q = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 1 0;0 1 1;1 0 1]};                   % 2 optimal actions per state
        sub = {[NaN NaN 1; 1 NaN NaN ; NaN 1 NaN];
            [NaN NaN 1; 1 NaN NaN ; NaN 1 NaN]};
end
for i = 1:length(Q)
    [R(i,:),V(i,:),pa(:,:,i)] = blahut_arimoto(ps,Q{i},beta); % R = policy complexity, V = average reward
end


% can be simulated or not
nSubj = length(DATA);
eix = num2str(fig(end))-'0';

for s = 1:nSubj
    data = DATA(s);
    C = unique(data.cond)';
    for c = 1:length(C)
        ix = find(data.cond==c);
        if bh
            ix = ix(end-29:end);
        end
        state = data.s(ix);
        action = data.a(ix);
        reward = data.r(ix);
        b = data.beta(ix);
        rt(s,c) = mean(data.rt(ix));

        R_data(s,c) = mutual_information(state, action ,0.1);
        V_data(s,c) = mean(reward);
        beta_data(s,c) = mean(b);

        win = 20; % groups of 20 trials
        for q = 1:length(state)-win
            R_data_mov(s,q,c) = mutual_information(state(q:q+win-1), action(q:q+win-1),0.1);
            V_data_mov(s,q,c) = mean(reward(q:q+win-1));
            beta_mov(s,q,c) = mean(b(q:q+win-1));
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
figure; nexttile; hold on; colororder(cmap(1:length(Q),:))
plot(R',V');
ylabel('Average reward')
xlabel('Policy complexity')

plot(R_data,V_data,'.','MarkerSize',20)
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
nexttile; hold on; colororder(cmap(1:length(Q),:));
b = barwitherr(sem(V_data,1),mean(V_data));
ylabel('average reward'); set(gca,'XTick',[]); ylim([0 1])
xticks([b.XEndPoints]); xticklabels(Q_labels)

% stochasticity
nexttile; hold on; colororder(cmap(1:length(Q),:));
barwitherr(sem(stochasticity,1),mean(stochasticity))
ylabel('stochasticity H(A|S)'); set(gca,'XTick',[]); ylim([0 2])
xticks([b.XEndPoints]); xticklabels(Q_labels)

% suboptimal actions
nexttile; hold on; colororder(cmap(1:length(Q),:))
barwitherr(sem(suboptimal,1),mean(suboptimal))
ylabel('p(suboptimal actions)'); set(gca,'XTick',[])
xticks([b.XEndPoints]); xticklabels(Q_labels); ylim([0 0.5])

% RT
nexttile; hold on; colororder(cmap(1:length(Q),:))
barwitherr(sem(rt,1),mean(rt))
ylabel('RT (ms)'); set(gca,'XTick',[])
xticks([b.XEndPoints]); xticklabels(Q_labels); %ylim([0 0.5])

% beta vs policy complexity
% nexttile; hold on;
% plot(R',beta)
% m = mean(R_data);
% for c = 1:length(Q)
%     ix = find(R(c,:)>=m(c),1); % find closest theoretical complexity value match
%     if isempty(ix)
%         ix = length(R);
%     end
%     plot(R(c,ix),beta(ix),'.','MarkerSize',40)
% end
% ylabel('\beta'); xlabel('policy complexity')
% ylim([0 10]);

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
nexttile; hold on; colororder(cmap(1:length(Q),:))
for c = 1:length(Q)
    plot(mean(R_data_mov(:,:,c)),mean(V_data_mov(:,:,c)),'-o')
end
plot(R',V')
ylabel('Average reward'); xlabel('Policy complexity');

nexttile; hold on
for c = 1:length(Q)
    shadedErrorBar([],mean(beta_mov(:,:,c)),sem(beta_mov(:,:,c),1),{'Color',cmap(c,:)},1)
end
ylabel('Estimated \beta'); xlabel('Trials');ylim([0 max(mean(beta_data))+10])
set(gcf, 'Position',  [0, 100, 800, 250])



end