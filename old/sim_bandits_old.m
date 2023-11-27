function sim_bandits_old(exp)

% Plan
% Experiment 1:
% Experiment 2:
% Experiment 3:

close all
rng(2)
switch exp
    
    case 'exp1'
        % 3 actions, N states (where N is a multiple of 2).
        % Create pairs of states that have very similar reward probabilities but differ in the optimal action. The prediction is that there will be similarity-based action slips: responding to the sub-optimal action in one state that is optimal in the other state. We can compare the slip rate to the probability of choosing this sub-optimal action to a 3rd action that is sub-optimal in both states.
        % Vary the number of pairs (1, 2, 3). Prediction is that similarity-based action slips will increase with more pairs.
        
        trials = 50;
        % 2 states
        %s2 = repmat(1:2,1,trials);
        %s2 = s2(randperm(length(s2)));
        
        % 4 states
        %s4 = repmat(1:4,1,trials);
        %s4 = s4(randperm(length(s4)));
        
        % 6 states
        %s6 = repmat(1:6,1,trials);
        %s6 = s6(randperm(length(s6)));
        
        s3 = repmat(1:3,1,trials);
        s3 = s3(randperm(length(s3)));
        
        s5 = repmat(1:5,1,trials);
        s5 = s5(randperm(length(s5)));
        
        %data.s = [s2 s4 s6];
        data.s = [s3 s3 s3];
        %data.cond = [3*ones(1,length(s)) 5*ones(1,length(s4)) 6*ones(1,length(s6))];
        data.cond = [1*ones(1,length(s3)) 2*ones(1,length(s3)) 3*ones(1,length(s3))];
        
        a = 1;
        b = 0.7;
        c = 0.7;
        data.reward = {[a b c; a b c; a b c];
            [a b c; a b c; b a c];
            [a b c; b a c; b c a]};
        
        %data.reward = {[0.8 0.7 0.7;0.7 0.8 0.7; 0.6 0.6 0.7];
        %    [0.9 0.8 0.8;0.8 0.9 0.8; 0.55 0.6 0.7; 0.7 0.65 0.65; 0.7 0.7 0.8]};
        
        %data.s = s6;
        %data.cond = 6*ones(1,length(s6));
        %data.reward = {[a b c; b a c; c a b; c b a; a c b; b c a]};
        
        %data.s = s4;
        %data.cond = 4*ones(1,length(s4));
        %data.reward = {[a b c; b a c; c a b; c b a]};
        
        %data.s = s2;
        %data.cond = 2*ones(1,length(s2));
        %data.reward = {[a b c; b a c]};
        
        % set agent parameters
        numAgents = 50;
        for i = 1:numAgents
            agent(i).m = 2;
            agent(i).C = 1; % [0-0.2] rand*0.2 | [0.4-0.6] rand*0.2+0.4 | [0.8-1] rand*0.2+0.8
            agent(i).lrate_V = 0.1;
            agent(i).lrate_Q = 0.1;
            agent(i).lrate_beta = 0.1;
            agent(i).alpha = 1;
            agent(i).beta = 0.3;
            agent(i).lrate_p = 0.1;
            agent(i).lrate_e = 0.1;
            agent(i).lrate_Z = unifrnd(0,0.3);
            simdata(i) = actor_critic_sim(agent(i), data);
            %simdata(i) = actor_critic_sim_cluster(agent(i), data);
        end
        
        
    case 'exp2'
        % Same setup as in Experiment 1, but hold the number of pairs fixed at 2 (or 4?) and manipulate the reward bonus across blocks (e.g., one low bonus blocks a randomly selected trial will be converted into 10 cents if reward was earned, and on high bonus blocks it's 50 cents).
        % Prediction is that similarity-based action slips will be lower on high bonus blocks.
        
        trials = 25;
        % 2 states
        s2 = repmat(1:2,1,trials);
        s2 = s2(randperm(length(s2)));
        
        data.s = [s2];
        data.cond = [2*ones(1,length(s2))];
        a = 1;
        b = 1;
        c = 0;
        data.reward = {[a b c; b a c]};
        
    case 'exp3'
        % Same setup as Experiment 1, but manipulate the frequency of one pair.
        % Prediction is that action slips are lower for high frequency pairs, and this also increases the frequency of the other pairs.
        
        % 4 states
        s4 = repmat(1:4,1,trials);
        s4 = s4(randperm(length(s4)));
        
        % 6 states
        s6 = repmat(1:6,1,trials);
        %s6 = s6(randperm(length(s6)));
        
        data.s = [s2 s4 s6];
        data.cond = [2*ones(1,length(s2)) 4*ones(1,length(s4)) 6*ones(1,length(s6))];
        a = 0.9;
        b = 0.7;
        c = 0.1;
        data.reward = {[a b c; b a c];
            [a b c; b a c; c a b; c b a];
            [a b c; b a c; c a b; c b a; a c b; b c a]};
        
end

% plots
cond = [unique(data.cond)];
nCond = length(cond);
for c = 1:nCond
    label{c} = strcat('Ns=',num2str(cond(c)));
end

% final_clusters = reshape([simdata.final_clusters], nCond,length([simdata.final_clusters])/nCond)';
% % agent.C vs number of clusters
% figure; hold on;
% for c = 1:nCond
%     subplot(1,nCond,c); hold on;
%     plot([agent.C],final_clusters(:,c),'k.','MarkerSize',20)
%     if c == 1
%         xlabel('Agent capacity')
%         ylabel('Final # of clusters')
%     end
%     title(label{c})
% end
% equalabscissa(1,nCond)
%
% % agent.lrate_Z vs number of clusters
% figure; hold on;
% for c = 1:nCond
%     subplot(1,nCond,c); hold on;
%     plot([agent.lrate_Z],final_clusters(:,c),'k.','MarkerSize',20)
%     if c == 1
%         xlabel('Agent cluster learning rate')
%         ylabel('Final # of clusters')
%     end
%     title(label{c})
% end
% equalabscissa(1,nCond)
%
% % final number of clusters discovered
% figure; hold on;
% barwitherr(sem(final_clusters,1),mean(final_clusters));  % average across subjects
% xlabel('state'); xticks([1:nCond]); xticklabels(label)
% ylabel('final # of clusters discovered')
%
% % average number of clusters discovered
% avg_clusters = reshape([simdata.mean_clusters],nCond,length([simdata.mean_clusters])/nCond)';
% figure; hold on;
% barwitherr(sem(avg_clusters,1),mean(avg_clusters));  % average across subjects
% xlabel('state'); xticks([1:nCond]); xticklabels(label)
% ylabel('average # of clusters discovered')
% for c = 1:nCond
%
% end
figure; hold on;
% number of times chose action in each state
for c = cond
    for i = 1:numAgents
        idx_cond = simdata(i).cond == c;
        sub_a  = [2 1]; low_a = [3 3];
        for s = 1:max(simdata(i).s(idx_cond))
            states = simdata(i).s(idx_cond);
            actions = simdata(i).a(idx_cond);
            idx = states == s;
            
            % find the suboptimal action
            %top_act = maxk(data.reward{find(cond==c)}',2);
            %[row,col] = find(data.reward{find(cond==c)} == top_act(2));
            %[~,ord] = sort(row); sub_a = col(ord);
            
            
            % find the least rewarding action
            %min_act = min(data.reward{find(cond==c)}');
            %[row,col] = find(data.reward{find(cond==c)} == min_act(1));
            %[~,ord] = sort(row); low_a = col(ord);
            
            for a = 1:max(actions)
                counts(s,a,i) = sum(actions(idx) == a);
                pas(s,a,i) = sum(actions(idx) == a)/sum(idx);
            end
        end
        %count_sub_a(i,1) = counts(1,sub_a(1),i);  % how many times chose the suboptimal action (2nd most rewarding)
        %count_sub_a(i,2) = counts(2,sub_a(2),i);  % how many times chose the suboptimal action (2nd most rewarding)
       % 
        %count_low_a(i,1) = counts(1,low_a(1),i); % how many times chose the last rewarding action
        %count_low_a(i,2) = counts(2,low_a(1),i); % how many times chose the last rewarding action
        
    end
    

    subplot(3,1,c); hold on; pause(1);
    h = barwitherr(sem(pas,3),mean(pas,3));
    %errorbar(data.reward{cond==c},[0 0 0],'LineWidth',1.5);
    
    legend('a_1','a_2','a_3')
    xlabel('state'); xticks([1:3]);
    ylabel('p(choose a|s)')
    
    
    % "supoptimal" action slips
    %subplot 312; hold on; pause(1);
    %h(1)=errorbar(mean(count_sub_a,1),sem(count_sub_a,1),'LineWidth',1.5); hold on;  box off
    %h(2)=errorbar(mean(count_low_a,1),sem(count_low_a,1),'LineWidth',1.5);
    %xlabel('state');  xticks([1:c]);
    %ylabel('# actions')
    %legend(h,{'suboptimal','worst'})
    %box off; ylim([0 10]); xlim([0 3])
    
    % worst action slip
    %subplot 313; hold on;
    %barwitherr(sem(count_sub_a-count_low_a,1),mean(count_sub_a-count_low_a,1)); pause(1);
    %xlabel('state');  xticks([1:c]);
    %ylabel('suboptimal-worst')
    %ylim([-5 5])
    
    %avg_sub_a(find(cond==c),:) = [sem(count_sub_a(:),1),mean(count_sub_a(:))];
    %avg_low_a(find(cond==c),:) = [sem(count_low_a(:),1),mean(count_low_a(:))];
    %diff_a(find(cond==c),:) = [sem(count_sub_a(:)-count_low_a(:),1) mean(count_sub_a(:)-count_low_a(:))];
    set(gcf,'Position',[200 200 500 700])
end


% plot average action slips for all three set sizes
figure; hold on;
h(1)=barwitherr(avg_sub_a(:,1), avg_sub_a(:,2)); hold on;
h(2)=barwitherr(avg_low_a(:,1), avg_low_a(:,2));
ylabel('# of times chose action')
legend(h,{'action slips','worst action'})
box off; ylim([0 20])

figure; hold on;
errorbar(diff_a(:,2),diff_a(:,1),'LineWidth',2,'Color','k')
xticks([1:nCond]); xticklabels(label)
ylabel('[suboptimal-worst] action slip')
xlim([0 4]); ylim([0 10])
%avg_sub_a(:,2)
end