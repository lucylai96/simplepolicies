function analyze_raw_collinsfrank18
load collinsfrank18_raw.mat
nSubj = size(data,2); % number of participants

nA = 3; % number of available actions in the task

for s = 1:nSubj

    %% specify trial blocks
    blocks = data(s).block_data{end}.blocks;

    num_trials0 = 0;
    %% loop over learning block
    for b = 1:length(blocks)
        ns(b)=blocks(b); % set size per block
        bdata = data(s).block_data{b}; % data (if desired)
        reward = bdata.Cor; % reward
        reward(reward<0) = NaN; % screen error trials (coded as "-1")
        num_trials = length(reward); % trials performed in block
        seq = bdata.seq(1:num_trials); % stimulus sequence
        rt = bdata.RT*1000; % convert s to ms if desired
        rt(rt<150) = NaN; % screen slip-up trials
        rttmp(b,1:num_trials) = rt; % store if desired
        sub_action = bdata.Code; % subject action
        cor_action = bdata.actionseq(1:num_trials); % correct action

        %% trial loop
        trials = num_trials0+1:num_trials0+num_trials;
        for i = 1:length(trials)
            cf18data(s).learningblock(trials(i)) = b;
            cf18data(s).ns(trials(i)) = blocks(b);
            cf18data(s).trial(trials(i)) = i;
            cf18data(s).state(trials(i)) = seq(i);
            %cf18data(s).iter(trials(i)) =
            cf18data(s).corchoice(trials(i)) = cor_action(i);
            cf18data(s).action(trials(i)) = sub_action(i);
            cf18data(s).cor(trials(i)) = sub_action(i)==cor_action(i);
            cf18data(s).reward(trials(i)) = reward(i);
            cf18data(s).rt(trials(i)) = rt(i);
        end
        num_trials0 = num_trials0 + num_trials;
    end % block
end % subjects

data = cf18data;
save('collinsfrank18.mat','data')
end