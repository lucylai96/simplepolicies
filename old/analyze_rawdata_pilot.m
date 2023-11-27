function data = analyze_rawdata_pilot(experiment)

%{
    Analyze raw jsPsych experiment data saved in .csv files

    USAGE:
        data = analyze_rawdata('pilot')
%}

prettyplot;
if nargin==1; cutoff=0.3; end

switch experiment
    case 'bonus'
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp3/data/','experiment/exp4/data/'};
        folder = {'experiment/exp1/data/','experiment/exp3/data/','experiment/exp4/data/'};
        %folder = {'experiment/test/data/'}
        subj = {};

        for s = 1:length(subj)
            for f = 1:length(folder)
                if exist([strcat(folder{f}, subj{s}) '.csv'])>1
                    A = readtable(strcat(folder{f}, subj{s}));

                    corr = sum(A.r==1);
                    incorr = sum(A.r==0);
                    data(s).performance(f) = corr/(corr+incorr);
                else
                    data(s).performance(f) = 0;
                end
            end
            data(s).bonus = round(mean(data(s).performance)*4, 2);
        end
        bonus = [cellstr(subj') {data.bonus}'];
        writecell(bonus,'bonus.csv');

    case 'pilot'
        folder = {'experiment/exp4/data/','experiment/exp1/data/','experiment/exp3/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot.mat';

        subj1 = {'A3KVKK1XLBTSN3','A1YFVXP4A1CXSF','AXY0D2AMLKE2A','A3POD149IG0DIW',...
            'A9LYIVFG3ZU4Z','ADIXVUPICNIY4','A12FTSX85NQ8N9','A1EFBEBVZP3D6G',...
            'A2K0L9M1ZZO5C9','A3QPVH0DRW0ZQV','A1DZMZTXWOM9MR','A2PR7FI9TP8XLD',...
            'AONSG5WOC3OX0','A16LUX6COW2EBP','A3JI3B5GTVA95F','A106QH27FETZ88',...
            'AQ9Y6WD8O72ZC', 'A1M24593XO5Z3C','A1CN1H9UODZ1E6','ADAL2H41ZBWAK',...
            'A22BBAU24IEHPL','A2T0STI1CPQBDR','A4XYCIUGXRTFY','A3QTJVLFYGWIGB',...
            'A299UKNV45FVI6','A16ENVVHDK1LQQ','A2Q8HV5LC6GBNA','A2WQT33K6LD9Z5',...
            'A1WW22TG79S8F','A2866TYG0D96LM'};

        subj2 = {'AKOAKQ1J9B9ET',...%'A5NE8TWS8ZV7B','AKVDY8OXNMQED','A1TSD3O3C3ZUT6'
            'ASF5V3K4IFP4K','A1FMVUYV72MUO3',...%'A3PRQ2GSU42718','A14KDNZSWDFIE7',
            'A2LKGF193ZR5JP','A1TPGXT718D68E',...%'A3P9TM5PRYBH90',,'A1I7H6RDJS4EKN'
            'A3G5OWGKHW6OL5','A82Q1HS5CPZ5I','A2PWUACCQI97J8',...%'A2DURCYLFT9UDY',
            'A3CSIM8V9IYXM7','A2HOEI5M6G883O',...%'ALF9AAZGQP4K5','A150MDVC0C92OT',
            'ATP2BJPDK4K2B','AAF1SJ9FCBF75','A39ES76IF6KQ1R','A1Q56N80RJLQ7S',...
            'A3N15463MQO5VF','A1NDMFN9A5G25G','AH4S22PWE826G',...%'A31A1PVXLJBISZ',
            'A26LOVXF4QZZCO'};%'A2HDEWY0ISLL7X',
        % subj = subj([ 3     5    12    13    17    19    23    24    25  26    35    37    38    46    47]); % exp 1 action 3
        % subj = subj([ 1     2     6     7     9    10    14    15    18    21    22    28    29    30    31    33    36    41    42    43 45]); % exp 1 action 2
        % subj = subj([4     8    11    16    20    27    32    34  40    44    48]); % exp 1 action 1
        % subj = subj([  2     4     6     7     8     9    10]); % exp 1 action 1 order 1
        % subj = subj([1     3     5    11    12]); % exp 1 action 1 order 2

        subj3 = {'A3V2XCDF45VN9X','A1KIL2V6SMJBGX','AA1IM0SAQ3XFM','A2IP3ZAFYGV8M9',...
            'A3RUL1OC4CAINK','ABBZGF22NICO7','AH1GZQFB3F9NH','A1ATL3G98SFW4V',...%'A1FHC4Z6QXDQSS',...
            'A1PRZC0JL283H7','AZ5ZYUCAQ0XDL','A14LOABUGAITBM','A1KAOUCQHCB3WV','A2PUL3ZDXOW0VZ',...
            'A16E8BQLG16N3F','A3L2VS3998R77L','A2U8IBLKZ3K6AY',...%'A2YC6PEMIRSOAA','AX8FMIUNJR0TD',...
            'A1IGMCPVC4D7UL','A32K4W6B31XWVR','A1YFLIT0E5OJG4','A193SP8INHA4MB',...%'A2EQEQNOVLJQ71',...
            'A1F6MWP9A0XLJQ','A7ERZELTAMWL5','A1DXGBSF4E3WTI','A3NXT3OVGL7QNR','A1DT7XOW0ISK0K',...
            'A2NR6DBUEXC3Y4'};

        subj = [subj3];


        Q(1).R = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1];             % p(s) manipulation
            [1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]};

        Q(2).R = {[1 0.333 0.333;0.333 1 0.333;0.333 0.333 1]; % marginal manipulation
            [1 0 0;1 1 0;1 0 1]};
        Q(3).R =  {[1 0.7 0;1 0.7 0;0.7 0 1];                  % time pressure
            [1 0.7 0;1 0.7 0;0.7 0 1]};

        Q(1).R = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];             % p(s) manipulation
            [0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8]};
        Q(2).R = {[1 0.333 0.333;0.333 1 0.333;0.333 0.333 1]; % marginal manipulation
            [1 0 0;1 1 0;1 0 1]};
        Q(3).R =  {[1 0.5 0;1 0.5 0;0.5 0 1];                  % time pressure
            [1 0.5 0;1 0.5 0;0.5 0 1]};

        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})
                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).N = data(s).N + data(s).exp(f).N;
                data(s).exp(f).Q = reward_cond;
                %data(s).exp(f).Q_actual = T.reward_cond_actual(idx);

                data(s).exp(f).reward_matrix_idx = T.reward_matrix_idx(idx);
                data(s).exp(f).cond = T.cond(idx);
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);

                order(s,f) = T.cond(idx(1));

                % general action bias? (before remapping)
                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).gab(c,a) = nansum(data(s).exp(f).a(data(s).exp(f).cond==c)==a);
                    end
                end

                data(s).exp(f).gab =  data(s).exp(f).gab./nansum(data(s).exp(f).gab,2);

                for c = unique(data(s).exp(f).cond)'
                    temp_a = [];
                    ix = data(s).exp(f).cond==c;
                    if unique(data(s).exp(f).reward_matrix_idx(ix))==2
                        real_a = [2 3 1];
                        kk(s,f) = 3;
                    elseif unique(data(s).exp(f).reward_matrix_idx(ix))==3
                        real_a = [3 1 2];
                        kk(s,f) = 2;
                    else
                        kk(s,f) = 1;
                        real_a = [1 2 3];
                    end

                    % reassign actions
                    for a = 1:3
                        temp_a(data(s).exp(f).a(ix)==a) = real_a(a);
                    end
                    temp_a(data(s).exp(f).a(ix)==-1) = -1;
                    data(s).exp(f).a(ix) = temp_a';
                end % for each condition

                % subjective action bias? (after remapping)
                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).sab(c,a) = nansum(data(s).exp(f).a(data(s).exp(f).cond==c)==a);
                    end
                end
                data(s).exp(f).sab = data(s).exp(f).sab./nansum(data(s).exp(f).sab,2);

                % store the learned policy for each condition
                for c = 1:2
                    ic = data(s).exp(f).cond == c;
                    if c == 2 && sum(data(s).exp(f).s(ic)==1)
                        flagg(s) = 0;
                    else flagg(s) = 1;
                    end
                    for ss = 1:3
                        for a = 1:3
                            temp(ss,a) = sum(data(s).exp(f).s(ic)==ss & data(s).exp(f).a(ic)==a);
                        end
                    end
                    data(s).exp(f).pas(:,:,c) = temp;
                end

                %                 % qualtrics
                %                 B = readtable(strcat(survey_folder, 'pilot.csv'));
                %                 idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                %                 S = table2array(B(idx,19:68));                      % only the data
                %
                %                 % question table of contents
                %                 % POMS2A: 1-15, higher = extreme moods
                %                 % MDQ: 15-28, higher = more bipolar spectrum
                %                 % BSDS: 31-50, higher = more bipolar
                %
                %                 temp = S(31);
                %                 code = [6 4 2 0];
                %
                %                 data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                %                 data(s).MDQ = sum(S(16:28)==1);
                %                 data(s).BSDS = code(temp) + nansum(S(32:50));
                %                 data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score

                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end

                % if subjects jam same action over and over
                for c = unique(data(s).exp(f).cond)'
                    id = data(s).exp(f).cond==c;
                    if std(data(s).exp(f).a(id))<0.1
                        flag(s) = 1;
                    end
                end
            end % for each folder / experiment
        end % for each subject

        %data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>mean(performance(:)));
        save('pilot_hp.mat', 'data');

    case 'pilot5'

        folder = {'experiment/exp1/data/','experiment/exp3/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot5.mat';

        subj = {'A14OQ52EFQAN2W','AZCGF2D7QIO10','A171S8E9IFSHH2','A351II0OWIWVX',...
            'A1PHDT66U6IK4Q','AKX4H8RT7BL7H','A6KOTWP7N7RLU','A1YSYI926BBOHW',...
            'A2ADQ1YRXFBEF0','A2ML0070M8FDK1','A19NGUFGC7KIGW','A2FYFCD16Z3PCC',...
            'A29N5E8YC6DB9Q','AD3V6XGQWRD6E','AH4LSAYFLV68I','A1JI19KPIVNL3Y',...
            'A35TUIBF05DKM4','A2XS49LRNX8PD4','A3DW6KSQPG6GVQ','A16YCPFPGW95OB'...
            'A24G8GL5FX1KAW','A2MWAXV1YRK5GH','A1RKHN69EI6ZPK','A3QNV0P3W7ZOAX'...
            'A12HZGOZQD5YK7','A1BHR5XQ16T7LA','A230VUDYOCRZ4N','A3KF6O09H04SP7'};%'A2NMAOYBBJTO0R',,'AKJLAFX2M86TP'

        Q(1).R = {[1 0.333 0.333;0.333 1 0.333;0.333 0.333 1]; % marginal manipulation
            [1 0 0;1 1 0;1 0 1]};
        Q(2).R =  {[1 0.7 0;1 0.7 0;0.7 0 1];       % time pressure
            [1 0.7 0;1 0.7 0;0.7 0 1]};
        Q(3).R = {[1 0.7 0.7;0.7 1 0.7;0.7 0.7 1];  % p(s) manipulation
            [1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]};

        %subj = subj([ 3     4     7     8     9    13    15    19    20   26    27]); % order = 1
        %subj = subj([ 1     2     5     6    10    11    12    14    16    17    18    21    22    24    28]); % order = 2
        %subj = subj([ 3     4     7     8     9    13    20    23    25    27]); %order = 1 and s2&3
        %subj = subj([ 2     3     4     5     6     7     8     9    10    12    13    16    18    20    22    23    25    27]); % s2 & s3

        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})
                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';
                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).N = data(s).N + data(s).exp(f).N;
                data(s).exp(f).Q = reward_cond;
                %data(s).exp(f).Q_actual = T.reward_cond_actual(idx);



                if any(T.reward_matrix_idx)
                    data(s).exp(f).reward_matrix_idx = T.reward_matrix_idx(idx);
                end
                if f==3
                    order(s) = unique(T.cond(idx));
                    if unique(T.cond(idx))==1
                        data(s).exp(f).cond(1:90,:) = 1;
                        data(s).exp(f).cond(91:length(T.cond(idx)),:) = 2;
                    else
                        data(s).exp(f).cond(1:150,:) = 2;
                        data(s).exp(f).cond(151:length(T.cond(idx)),:) = 1;
                    end
                else
                    data(s).exp(f).cond = T.cond(idx);
                end
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);
                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).gab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % general action bias? (before remapping)
                    end
                end

                data(s).exp(f).gab =  data(s).exp(f).gab./sum(data(s).exp(f).gab,2);

                if f<=2 % marginal & time pressure experiments
                    for c = unique(data(s).exp(f).cond)'
                        temp_a = [];
                        ix = data(s).exp(f).cond==c;
                        if unique(data(s).exp(f).reward_matrix_idx(ix))==2
                            real_a = [2 3 1];
                        elseif unique(data(s).exp(f).reward_matrix_idx(ix))==3
                            real_a = [3 1 2];
                        else
                            real_a = [1 2 3];
                        end

                        % reassign actions
                        for a = 1:3
                            temp_a(data(s).exp(f).a(ix)==a) = real_a(a);
                        end
                        temp_a(data(s).exp(f).a(ix)==-1) = -1;
                        data(s).exp(f).a(ix) = temp_a';
                    end % for each condition

                elseif f==3 % for exp 3 (assymmetrical distribution)
                    % swapping states if needed
                    temp_s = [];
                    temp_a = [];
                    id = data(s).exp(f).cond==2;
                    for ss = 1:3 % only if s2 or s3 is actually "s1"
                        if sum(data(s).exp(f).s(id) == ss) > 80
                            if ss == 2
                                real_s = [2 1 3];
                                real_a = [2 1 3];
                                kk(s) = ss;
                            elseif ss == 3
                                real_s = [3 2 1];
                                real_a = [3 2 1];
                                kk(s) = ss;
                            else
                                real_s = [1 2 3];
                                real_a = [1 2 3];
                                kk(s) = ss;
                            end
                        end
                    end
                    % reassign states
                    for ss = 1:3
                        temp_s(data(s).exp(f).s(id)==ss) = real_s(ss);
                    end
                    data(s).exp(f).s(id) = temp_s';

                    % reassign actions
                    for a = 1:3
                        temp_a(data(s).exp(f).a(id)==a) = real_a(a);
                    end

                    temp_a(temp_a<1) = -1;
                    data(s).exp(f).a(id) = temp_a';
                end

                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).sab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % subjective action bias? (after remapping)
                    end
                end
                data(s).exp(f).sab = data(s).exp(f).sab./sum(data(s).exp(f).sab,2);

                for c = 1:2
                    ic = data(s).exp(f).cond == c;
                    for ss = 1:3
                        for a = 1:3
                            temp(ss,a) = sum(data(s).exp(f).s(ic)==ss & data(s).exp(f).a(ic)==a);
                        end
                    end
                    data(s).exp(f).pas(:,:,c) = temp;
                end

                %why
                % qualtrics
                %B = readtable(strcat(survey_folder, 'pilot1.csv'));
                %idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                %S = table2array(B(idx,19:68)); % only the data

                % question table of contents
                % POMS2A: 1-15, higher = extreme moods
                % MDQ: 15-28, higher = more bipolar spectrum
                % BSDS: 31-50, higher = more bipolar

                %temp = S(31);
                %code = [6 4 2 0];

                %data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                %data(s).MDQ = sum(S(16:28)==1);   %
                %data(s).BSDS = code(temp) + nansum(S(32:50));
                %data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score

                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
                % if subjects jam same action over and over
                for c = unique(data(s).exp(f).cond)'
                    id = data(s).exp(f).cond==c;
                    if std(data(s).exp(f).a(id))<0.2
                        flag(s) = 1;
                    end
                end
            end % for each folder / experiment
        end % for each subject

        data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>mean(performance(:)));
        save('pilot5_hp.mat', 'data');

    case 'pilot4'
        % with redesign
        folder = {'experiment/exp1/data/','experiment/exp3/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot4.mat';

        subj = {'A37GOI3N77WX21','A6THOSGKI6HQC','A2EK1HDV4I4GSK','A2HOUSKURBF8UA',...
            'A11WCFPJSR5VZP','A22LRKFP5S22GR','A3CH1Z6J9R38G9',...%,'A1CPY1HLCFTIL1'
            'A1T579QEGUZKIP','A1I0DV4B4MFQCL','ACKG8OU1KHKO2',...%'A1BJFYHXK6YDX1',
            'A2SKY4RRWII0BF','A19CB2C4GY4C60','ALYR5CI2SM2JC','ACJ6NSCIWMUZI',...
            'A2ZSL0EDN3H4AT','AZ8JL3QNIPY4U','A36W6GSNGVP8CO','AR5RKWHR0DUCS',...
            'A1RATFICCKLCQ','A17K1CHOI773VZ','AIXZNUNYZHM4I','A24IWWIUPASCQJ',...
            'A11JZFATJVBFN0','A24LB89P1BPKKF','A25FH7PXC446RG','AR4FNR7Z2WLC8'};%,'A19TF4J8VFW81' ,'A3ROADR7T6811'


        Q(1).R =  {[1 0.333 0.333;0.333 1 0.333;0.333 0.333 1]; % marginal manipulation
            [1 0 0;1 1 0;1 0 1]};
        Q(2).R =  {[1 0.7 0;1 0.7 0;0.7 0 1];       % time pressure
            [1 0.7 0;1 0.7 0;0.7 0 1]};
        Q(3).R = {[1 0.7 0.7;0.7 1 0.7;0.7 0.7 1];  % p(s) manipulation
            [1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]};

        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})

                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';

                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).N = data(s).N + data(s).exp(f).N;
                data(s).exp(f).Q = reward_cond;
                %data(s).exp(f).Q_actual = T.reward_cond_actual(idx);
                if any(T.reward_matrix_idx)
                    data(s).exp(f).reward_matrix_idx = T.reward_matrix_idx(idx);
                end
                if f==3
                    order(s) = unique(T.cond(idx));
                    if unique(T.cond(idx))==1
                        data(s).exp(f).cond(1:length(T.cond(idx))/2,:) = 1;
                        data(s).exp(f).cond(length(T.cond(idx))/2 + 1:length(T.cond(idx)),:) = 2;
                    else
                        data(s).exp(f).cond(1:length(T.cond(idx))/2,:) = 2;
                        data(s).exp(f).cond(length(T.cond(idx))/2 + 1:length(T.cond(idx)),:) = 1;
                    end
                else
                    data(s).exp(f).cond = T.cond(idx);
                end
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);
                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).gab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % general action bias? (before remapping)
                    end
                end
                data(s).exp(f).gab =  data(s).exp(f).gab./sum(data(s).exp(f).gab,2);
                if f<3 % marginal & time pressure experiments
                    for c = unique(data(s).exp(f).cond)'
                        temp_a = [];
                        ix = data(s).exp(f).cond==c;
                        if unique(data(s).exp(f).reward_matrix_idx(ix))==2
                            real_a = [2 3 1];
                        elseif unique(data(s).exp(f).reward_matrix_idx(ix))==3
                            real_a = [3 1 2];
                        else
                            real_a = [1 2 3];
                        end

                        % reassign actions
                        for a = 1:3
                            temp_a(data(s).exp(f).a(ix)==a) = real_a(a);
                        end
                        temp_a(data(s).exp(f).a(ix)==-1) = -1;
                        data(s).exp(f).a(ix) = temp_a;
                    end % for each condition

                else % for exp 3 (assymmetrical distribution)
                    % swapping states if needed
                    temp_s = zeros(length(data(s).exp(f).s)/2,1);
                    temp_a = zeros(length(data(s).exp(f).a)/2,1);
                    id = data(s).exp(f).cond==2;
                    for ss = 1:3 % only if s2 or s3 is actually "s1"
                        if sum(data(s).exp(f).s(id) == ss) > 40
                            if ss == 2
                                real_s = [2 1 3];
                                real_a = [2 1 3];
                            elseif ss == 3
                                real_s = [3 2 1];
                                real_a = [3 2 1];
                            else
                                real_s = [1 2 3];
                                real_a = [1 2 3];
                            end
                            kk(s) = ss;
                        end
                    end
                    % reassign states
                    for ss = 1:3
                        temp_s(data(s).exp(f).s(id)==ss) = real_s(ss);
                    end
                    data(s).exp(f).s(id) = temp_s;

                    % reassign actions
                    for a = 1:3
                        temp_a(data(s).exp(f).a(id)==a) = real_a(a);
                    end
                    data(s).exp(f).a(id) = temp_a;


                end
                for c = 1:2
                    for a = 1:3
                        data(s).exp(f).sab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % subjective action bias? (after remapping)
                    end
                end
                data(s).exp(f).sab = data(s).exp(f).sab./sum(data(s).exp(f).sab,2);


                % qualtrics
                %B = readtable(strcat(survey_folder, 'pilot1.csv'));
                %idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                %S = table2array(B(idx,19:68)); % only the data

                % question table of contents
                % POMS2A: 1-15, higher = extreme moods
                % MDQ: 15-28, higher = more bipolar spectrum
                % BSDS: 31-50, higher = more bipolar

                %temp = S(31);
                %code = [6 4 2 0];

                %data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                %data(s).MDQ = sum(S(16:28)==1);   %
                %data(s).BSDS = code(temp) + nansum(S(32:50));
                %data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score

                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
                % if subjects jam same action over and over
                if std(data(s).exp(f).a)<0.1
                    flag(s) = 1;
                end
            end % for each folder / experiment
        end % for each subject

        data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>mean(performance(:)));
        save('pilot4_hp.mat', 'data');

    case 'pilot3'
        % with harder probabilities
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp3/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot3.mat';

        subj = {'A27VK38SRSSHV3','A16YCPFPGW95OB','A2E0LU8V4EUX5C','A2JDYN6QM8M5UN',...
            'A1ROEDVMTO9Y3X','ACJNWSBIVI46H','A2GXS7E934VJQ1','APVZGZM1RA3AZ',...
            'A5NE8TWS8ZV7B','A3HFZPC8QR1Y54','A2K0L9M1ZZO5C9','A1OOCYEFLAJD98','ARFJTVZE5IKLC',...
            'A1DZMZTXWOM9MR','AR5M3HHTQV9QY','A3EA4SHCLJ1UZQ','A1FP3SH704X01V'...%'A1EFBEBVZP3D6G'
            'A1SN7EOZUW5VP3','A1AYQ8E01NSY5Z','A1PRZC0JL283H7','AQ9Y6WD8O72ZC','A3I40B0FATY8VH',...
            'A3ROADR7T6811','A1YZ0ETOCJO1B2','A24G8GL5FX1KAW','A2Q8HV5LC6GBNA','A1DXGBSF4E3WTI','A1Q56N80RJLQ7S','A2ML0070M8FDK1'};


        Q(1).R =  {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 1 0;0 1 1;1 0 1]};
        Q(2).R = {[1 0.7 0;0 1 0.7;0.7 0 1];         % each state has its own optimal action
            [1 0.7 0;1 0.7 0;0.7 0 1]};
        Q(3).R =  {[1 0.7 0;1 0.7 0;0.7 0 1]        % 2 states with same optimal action
            [1 0.7 0;1 0.7 0;0.7 0 1]};
        Q(4).R = {[1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]        % 1 optimal action per state
            [1 0.7 0.7;0.7 1 0.7;0.7 0.7 1]};


        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                if exist([strcat(folder{f}, subj{s}) '.csv'])>1
                    T = readtable(strcat(folder{f}, subj{s}));
                    A = table2cell(T);
                    R = Q(f).R;
                    corr = sum(T.r==1);
                    incorr = sum(T.r==0);
                    data(s).pcorr(f) = corr/(corr+incorr);

                    k = 1; reward_cond = []; idx = []; cond = [];
                    for i = 1:size(T,1)
                        if ~isempty(T.reward_cond{i})

                            reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';

                            for j = 1:length(R)
                                if isequal(reward_cond(:,:,k),R{j})
                                    cond(k) = j;
                                end
                            end
                            idx(k) = i;
                            k = k+1;
                        end
                    end

                    data(s).ID = subj{s};
                    data(s).exp(f).N = length(idx);
                    data(s).N = data(s).N + data(s).exp(f).N;
                    data(s).exp(f).Q = reward_cond;
                    if f > 2
                        data(s).exp(f).cond = [cond(1:length(cond)/2)'-1; cond(1:length(cond)/2)'];
                    else
                        data(s).exp(f).cond = cond';
                    end
                    data(s).exp(f).s = T.s(idx);
                    data(s).exp(f).a = T.a(idx);
                    data(s).exp(f).r = T.r(idx);
                    data(s).exp(f).rt = T.reactionTime(idx);

                    for a = 1:3
                        data(s).exp(f).gab(a) = sum(data(s).exp(f).a==a); % general action bias? (before remapping)
                    end

                    % qualtrics
                    %B = readtable(strcat(survey_folder, 'pilot1.csv'));
                    %idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                    %S = table2array(B(idx,19:68)); % only the data

                    % question table of contents
                    % POMS2A: 1-15, higher = extreme moods
                    % MDQ: 15-28, higher = more bipolar spectrum
                    % BSDS: 31-50, higher = more bipolar

                    %temp = S(31);
                    %code = [6 4 2 0];

                    %data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                    %data(s).MDQ = sum(S(16:28)==1);   %
                    %data(s).BSDS = code(temp) + nansum(S(32:50));
                    %data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score



                    % if subjects stopped responding
                    if sum(data(s).exp(f).a == -1) > 20
                        flag(s) = sum(data(s).exp(f).a == -1);
                    else
                        flag(s) = 0;
                    end
                    % if subjects jam same action over and over
                    if std(data(s).exp(f).a)<0.1
                        flag(s) = 1;
                    end
                end
            end % for each folder / experiment
        end % for each subject

        data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})
        %scatterbar(b,performance)
        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>mean(performance(:)));
        save('pilot3_hp.mat', 'data');

    case 'pilot2'
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp3/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot2.mat';

        subj = {'A6THOSGKI6HQC','AZCGF2D7QIO10','A1BJFYHXK6YDX1','AZ8JL3QNIPY4U',...
            'A17K1CHOI773VZ','A1UOGYZFJF4BKW','A1PHDT66U6IK4Q','ALYR5CI2SM2JC',...
            'A13MAWPV4T44I2','A29N5E8YC6DB9Q','ACKG8OU1KHKO2',...%'AIXZNUNYZHM4I'
            'A1YSYI926BBOHW','A1CPY1HLCFTIL1','A2KLJKDG90K1PP','A1I7H6RDJS4EKN',...
            'A1I0DV4B4MFQCL','AIC2D8A9UQO8S','A2J1ANUL0BYKUK',...%'AW0K78T4I2T72'
            'A2VZBQLSFZC519','A1NLJ1L4VCQYV2','A2JWAD9JQNA5ON','A3LVLZS8S41ZD7',...
            'A37GOI3N77WX21','A3NXT3OVGL7QNR','A34YDGVZKRJ0LZ',...%'A3AHD1NV5XCOF'
            'A3T3XXV4VDXPAG','A25PFSORDO3SWQ'};

        Q(1).R =  {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 1 0;0 1 1;1 0 1]};
        Q(2).R = {[1 0.5 0;0 1 0.5;0.5 0 1];         % each state has its own optimal action
            [1 0.5 0;1 0.5 0;0.5 0 1]};
        Q(3).R =  {[1 0.5 0;1 0.5 0;0.5 0 1]        % 2 states with same optimal action
            [1 0.5 0;1 0.5 0;0.5 0 1]};
        Q(4).R = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]        % 1 optimal action per state
            [1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]};


        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})

                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';

                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).N = data(s).N + data(s).exp(f).N;
                data(s).exp(f).Q = reward_cond;
                if f > 2
                    data(s).exp(f).cond = [cond(1:length(cond)/2)'-1; cond(1:length(cond)/2)'];
                else
                    data(s).exp(f).cond = cond';
                end
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);

                % qualtrics
                %B = readtable(strcat(survey_folder, 'pilot1.csv'));
                %idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                %S = table2array(B(idx,19:68)); % only the data

                % question table of contents
                % POMS2A: 1-15, higher = extreme moods
                % MDQ: 15-28, higher = more bipolar spectrum
                % BSDS: 31-50, higher = more bipolar

                %temp = S(31);
                %code = [6 4 2 0];

                %data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                %data(s).MDQ = sum(S(16:28)==1);   %
                %data(s).BSDS = code(temp) + nansum(S(32:50));
                %data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score



                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
                % if subjects jam same action over and over
                if std(data(s).exp(f).a)<0.1
                    flag(s) = 1;
                end
            end % for each folder / experiment
        end % for each subject

        data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})
        %scatterbar(b,performance)
        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');



    case 'pilot1'
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot1.mat';

        subj = {'A10BH9PYCYUKDJ','A13MAWPV4T44I2','A1AYQ8E01NSY5Z','A1DUPOUC9RNU4L',...
            'A1JWKT0IS06YKL','A1NLJ1L4VCQYV2','A1XODDMY1SJ0H9','A1YZ0ETOCJO1B2',...
            'A20TOOYZRH6KUZ','A227W90ZO5I9RZ','A2DLV3WN24WTDS','A2199FQE7R6RF6',...
            'A2DVV59R1CQU6T','A2E0LU8V4EUX5C','A2FB5UQTR3E0NX','A2KW87ZD2ELYNG',...
            'A2MX0EF342FY3P','A2NXMRPHG86N2T','A2ZDEERVRN5AMC','A324M5ZRHX7RUV',...
            'A36SM7QM8OK3H6','A3AY0315YWWNXY','A3CCFD0700KTPV','A3L0DCUXI7X3A9',...
            'A3TZ6KG6SP9RDT','A5P12YJP805RG','A7TI4X4LRGQA0','ACSS93E03ZUGX',...
            'AW0K78T4I2T72','AZCGSVDT79E6X'};

        Q(1).R =  {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]
            [1 1 0;0 1 1;1 0 1]};
        Q(2).R = {[1 0.5 0;0 1 0.5;0.5 0 1];
            [1 0.5 0;1 0 0.5;0.5 0 1]};
        Q(3).R =  {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]
            [1 1 0;0 1 1;1 0 1]};


        for s = 1:length(subj)
            data(s).N = 0;
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})

                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';

                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).N = data(s).N + data(s).exp(f).N;
                data(s).exp(f).Q = reward_cond;
                data(s).exp(f).cond = cond';
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);

                % qualtrics
                B = readtable(strcat(survey_folder, 'pilot1.csv'));
                idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                S = table2array(B(idx,19:68)); % only the data

                % question table of contents
                % POMS2A: 1-15, higher = extreme moods
                % MDQ: 15-28, higher = more bipolar spectrum
                % BSDS: 31-50, higher = more bipolar

                temp = S(31);
                code = [6 4 2 0];

                data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                data(s).MDQ = sum(S(16:28)==1);   %
                data(s).BSDS = code(temp) + nansum(S(32:50));
                data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score


                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
            end % for each folder / experiment
        end % for each subject

        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})
        scatterbar(b,performance)
        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        %data = data(mean(performance,2)>0.8);
        %save('pilot1_hp.mat', 'data');

    case 'test'
        folder = {'experiment/test/data/'};
        savepath = 'test.mat';

        subj = {'A1YSYI926BBOHW','A2K0L9M1ZZO5C9','A6THOSGKI6HQC','AZ8JL3QNIPY4U',...
            'AQ9Y6WD8O72ZC','A1I7H6RDJS4EKN','A24IWWIUPASCQJ','A1BJFYHXK6YDX1',...
            'A3I40B0FATY8VH','A3NXT3OVGL7QNR','A3G5OWGKHW6OL5','A1AYQ8E01NSY5Z','A3TZ6KG6SP9RDT',...
            'A5NE8TWS8ZV7B','A1PHDT66U6IK4Q','A25GC0CJO1NNDZ','A1HKYY6XI2OHO1',...
            'A1DT7XOW0ISK0K','A24G8GL5FX1KAW','A1I16447TV7B9D','A17K1CHOI773VZ',...
            'A1T579QEGUZKIP','A1MWCDBGZLHJPI','A3BSK47WPPE876','AYW62R027PUT1'};


        Q(1).R =  {[0.7 0.2 0;0 0.7 0.2;0.2 0 0.7];
            [0.7 0.2 0;0.7 0 0.2;0.2 0 0.7]};

        for s = 1:length(subj)
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})
                        reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';
                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).exp(f).Q = reward_cond;
                data(s).exp(f).cond = cond';
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);

                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
            end % for each folder / experiment
        end % for each subject

        save(savepath, 'data');

    case 'pilot0'
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp3/data/','experiment/exp4/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'pilot.mat';

        subj = {'A14DC1USXBIRXU','A1BHR5XQ16T7LA','A1GRPIBHW72HDU','A1SPIAJZORHFT0',...
            'A1XQOZV8LQDM22','A20TOOYZRH6KUZ','A25FH7PXC446RG','A2BK9RMC0NOIH8',...
            'A2D28BVEFUUTMO','A2DLV3WN24WTDS','A2FP41BSPG0Y4A','A2WAADBO0ZF89K',...
            'A2YC6PEMIRSOAA','A3DW6KSQPG6GVQ','A3HXCMU4MOPSQI','A3OZ8KF0HWSVWK',...
            'A3RUL1OC4CAINK','A41APS6V2Z1FJ','AEK2SAEL9GG39','AF2BJOFFCZQWY',...
            'AMHUDJ44HF1ZH','AOAZMLP27GD81','AZNIEFUIVB2H0'};
        subj = {'A3HXCMU4MOPSQI','A20TOOYZRH6KUZ','A2DLV3WN24WTDS','A2YC6PEMIRSOAA',...
            'A1BHR5XQ16T7LA','A2FP41BSPG0Y4A','A1GRPIBHW72HDU','A2D28BVEFUUTMO',...
            'AEK2SAEL9GG39','A41APS6V2Z1FJ','A1SPIAJZORHFT0','AOAZMLP27GD81','A3RUL1OC4CAINK',...
            'AF2BJOFFCZQWY','A3DW6KSQPG6GVQ','A3OZ8KF0HWSVWK','AZNIEFUIVB2H0',...
            'A14DC1USXBIRXU','A1XQOZV8LQDM22','A2WAADBO0ZF89K','A2BK9RMC0NOIH8',...
            'AMHUDJ44HF1ZH','A25FH7PXC446RG'};
        %'A2Z6NL0CTXY0ZB',A235DXY5FJN0IW says completed but didnt?
        Q(1).R = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];     % 1 optimal action per state
            [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];           % 2 optimal actions per state
            [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};                % 2 optimal actions per state
        Q(2).R = {[0.7 0 0.8;0.7 0.8 0;0.7 0.8 0];           % a_1 suboptimal for 3 states
            [0.5 0 1;1 0.5 0;0 1 0.5]};                      % each state has its own suboptimal action
        Q(3).R =  {[0.8 0.2;0.8 0.2;0.2 0.8;0.2 0.8];    % 2 states with same optimal action
            [0.2 0.8;0.2 0.8;0.2 0.8;0.8 0.2]};      % 3 states with same optimal action
        Q(4).R = {[0.8 0.2 0.2;0.2 0.8 0.2;0.2 0.2 0.8];     % 1 optimal action per state
            [0.8 0.8 0.2;0.2 0.8 0.8;0.8 0.2 0.8];           % 2 optimal actions per state
            [0.6 0.6 0;0 0.6 0.6;0.6 0 0.6]};                % 2 optimal actions per state

        for s = 1:length(subj)
            for f = 1:length(folder)
                T = readtable(strcat(folder{f}, subj{s}));
                A = table2cell(T);
                R = Q(f).R;
                corr = sum(T.r==1);
                incorr = sum(T.r==0);
                data(s).pcorr(f) = corr/(corr+incorr);

                k = 1; reward_cond = []; idx = []; cond = [];
                for i = 1:size(T,1)
                    if ~isempty(T.reward_cond{i})
                        if f == 3
                            reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),2,[])';
                        else
                            reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';
                        end
                        for j = 1:length(R)
                            if isequal(reward_cond(:,:,k),R{j})
                                cond(k) = j;
                            end
                        end
                        idx(k) = i;
                        k = k+1;
                    end
                end

                data(s).ID = subj{s};
                data(s).exp(f).N = length(idx);
                data(s).exp(f).Q = reward_cond;
                data(s).exp(f).cond = cond';
                data(s).exp(f).s = T.s(idx);
                data(s).exp(f).a = T.a(idx);
                data(s).exp(f).r = T.r(idx);
                data(s).exp(f).rt = T.reactionTime(idx);

                %% qualtrics
                %                 B = readtable(strcat(survey_folder, 'pilot.csv')); B = B(2:end,:);
                %                 idx = find(strcmp(table2cell(B(:,70)),subj(s))==1); % get mturkIDs
                %                 S = table2array(B(idx,19:68)); % only the data

                % question table of contents
                % POMS2A: 1-15, higher = extreme moods
                % MDQ: 15-28, higher = more bipolar spectrum
                % BSDS: 31-50, higher = more bipolar

                %                 temp = S(31);
                %                 code = [6 4 2 0];

                %                 data(s).POMS2A = sum(S(1:15)); % in the moment assessment of mood and states
                %                 data(s).MDQ = sum(S(16:28));   %
                %                 data(s).BSDS = code(temp) + nansum(S(32:50));
                %                 data(s).qualtrics = [data(s).POMS2A data(s).MDQ data(s).BSDS]; % general score

                % if subjects stopped responding
                if sum(data(s).exp(f).a == -1) > 20
                    flag(s) = sum(data(s).exp(f).a == -1);
                else
                    flag(s) = 0;
                end
            end % for each folder / experiment
        end % for each subject

        figure; hold on;
        performance = reshape([data.pcorr],4,[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3','Exp4'})
        scatterbar(b,performance)
        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>0.65);
        save('pilot_lp.mat', 'data');


    case 'test2'

        folder = {'experiment/exp4/data/'};
        savepath = 'test2.mat';

        subj1 = {'A1LDP0JIA4IKAQ','A32HHTM9N6C67R','A1UOGYZFJF4BKW','A1CN1H9UODZ1E6',...
            'A1I7H6RDJS4EKN','A14LOABUGAITBM','A1WW22TG79S8F','A1DKR1102NZROG',...
            'A39ES76IF6KQ1R','A2HOEI5M6G883O','A3G5OWGKHW6OL5','A1N53V41FMCR7Q',...
            'A598UDLZZZAJ3','AVJ7MQZ6AQF5M','A1K2R6FBPUA5TQ','A1E7IRBPHID9JC','AEW3RUARJ1K8R',...
            'A1ZLLYRW6GIVC7','A37E36IPU0BJX5','AO9VHGJ8RGOZJ','A1FBEM5WECB986','A16ENVVHDK1LQQ',...
            'A1BM57TUNAQIXM','A16K7X677N4WN6','A24MNMHSFYW6B',...%'A31A1PVXLJBISZ'
            'A2K0L9M1ZZO5C9','A2R0I39QFFQKXH','A2KDYSLV030FVX'};
        subj2 = {'A150MDVC0C92OT','A2VZBQLSFZC519','A3H3BTRV6I3LYU',...
            'A3V2XCDF45VN9X','A11LL3J3YSXB4U','A2FP41BSPG0Y4A','AYR7W8E2KALFA',...
            'A2BK9RMC0NOIH8','AW0MG225VXWCN','A3CSIM8V9IYXM7','A4XYCIUGXRTFY','A3OZ8KF0HWSVWK',...
            'A7VA2Y4H6U31O','AMVBT3XDCQBHI','A10249252O9I20MRSOBVF',...%,'A2DFAYR97N5T37'
            'A1KZ97QBNRPVCT','A2T1LNI80EPOQR','A2WAADBO0ZF89K','A3PGS1Q1XAY79I',...
            'A3KKXA7COL5JHL','A3Q1EZDNIUK41P','APGX2WZ59OWDN','A1P47Q6LZPLQ6P'};
        subj3 = {'AT0COJ1G23ZB0','A17TKHT8FEVH0R','A320QA9HJFUOZO','ADIXVUPICNIY4',...
            'A195MOXRMNHRVT','A1FMVUYV72MUO3','AOOLS8280CL0Z','A2VAL2BRKVSUB5',...
            'A222GZB608T1B8','A92BS1Y7V15Y2',...%'APVZGZM1RA3AZ','A1DZMZTXWOM9MR',
            'A12J4IRF5Z06BT','A2GV9WSNSPX53','A28HB7240OFGEW',...%'AEK2SAEL9GG39',
            'AFK9ALQK5GPNG','AONSG5WOC3OX0','A3TMVAECAVF9X5',...%,'A207IHY6GERCFO'
            'AYW62R027PUT1','A39KKDB8CFBGCC','A3KVKK1XLBTSN3','A3QPVH0DRW0ZQV','A13WTEQ06V3B6D'};

        subj = [subj1 subj2(1:4) subj3(4:8)];

        % when Q2 comes first, performance is better and no compression
        % when Q1 comes first, Q2 shows effects (x2)
        Q.R = {[1 0.5 0.5;0.5 1 0.5;0.5 0.5 1];  % p(s) manipulation
            [1 0.5 0.5;0.5 1 0.5;0.5 0.5 1]};
        f = 1;
        for s = 1:length(subj)
            data(s).N = 0;
            T = readtable(strcat(folder{f}, subj{s}));
            A = table2cell(T);
            R = Q(f).R;
            corr = sum(T.r==1);
            incorr = sum(T.r==0);
            data(s).pcorr = corr/(corr+incorr);

            k = 1; reward_cond = []; idx = [];
            for i = 1:size(T,1)
                if ~isempty(T.reward_cond{i})

                    reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';

                    for j = 1:length(R)
                        if isequal(reward_cond(:,:,k),R{j})
                            cond(k) = j;
                        end
                    end
                    idx(k) = i;
                    k = k+1;
                end
            end

            data(s).ID = subj{s};
            data(s).exp(f).N = length(idx);
            data(s).N = data(s).N + data(s).exp(f).N;
            data(s).exp(f).Q = reward_cond;
            %data(s).exp(f).Q_actual = T.reward_cond_actual(idx);

            %if any(T.reward_matrix_idx)
            %    data(s).exp(f).reward_matrix_idx = T.reward_matrix_idx(idx);
            %end

            if unique(T.cond(idx))==1
                data(s).exp(f).cond(1:90,:) = 1;
                data(s).exp(f).cond(91:240,:) = 2;
            else
                data(s).exp(f).cond(1:150,:) = 2;
                data(s).exp(f).cond(151:240,:) = 1;
            end
            %order(s) = unique(T.cond(idx));
            data(s).exp(f).s = T.s(idx);
            data(s).exp(f).a = T.a(idx);
            data(s).exp(f).r = T.r(idx);
            data(s).exp(f).rt = T.reactionTime(idx);

            for c = 1:2
                ic = data(s).exp(f).cond == c;
                for ss = 1:3
                    for a = 1:3
                        temp(ss,a) = sum(data(s).exp(f).s(ic)==ss & data(s).exp(f).a(ic)==a);
                    end
                end
                data(s).exp(f).pas(:,:,c) = temp;
            end

            for c = 1:2
                for a = 1:3
                    data(s).exp(f).gab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % general action bias? (before remapping)
                end
            end

            data(s).exp(f).gab =  data(s).exp(f).gab./sum(data(s).exp(f).gab,2);

            % swapping states if needed
            temp_s = [];
            temp_a = [];
            id = data(s).exp(f).cond==2;
            for ss = 1:3 % only if s2 or s3 is actually "s1"
                if sum(data(s).exp(f).s(id) == ss) > 80
                    if ss == 2
                        real_s = [2 1 3];
                        real_a = [2 1 3];
                        kk(s) = 2;
                    elseif ss == 3
                        real_s = [3 2 1];
                        real_a = [3 2 1];
                        kk(s) = 3;
                    else
                        real_s = [1 2 3];
                        real_a = [1 2 3];
                        kk(s) = 1;
                    end
                end
            end
            % reassign states
            for ss = 1:3
                temp_s(data(s).exp(f).s==ss) = real_s(ss);
            end
            data(s).exp(f).s = temp_s';

            % reassign actions
            for a = 1:3
                temp_a(data(s).exp(f).a==a) = real_a(a);
            end

            temp_a(data(s).exp(f).a==-1) = -1;
            data(s).exp(f).a = temp_a';


            for c = 1:2
                for a = 1:3
                    data(s).exp(f).sab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % subjective action bias? (after remapping)
                end
            end
            data(s).exp(f).sab = data(s).exp(f).sab./sum(data(s).exp(f).sab,2);

            for c = 1:2
                ic = data(s).exp(f).cond == c;
                for ss = 1:3
                    for a = 1:3
                        temp(ss,a) = sum(data(s).exp(f).s(ic)==ss & data(s).exp(f).a(ic)==a);
                    end
                end
                data(s).exp(f).pas(:,:,c) = temp;
            end

            % if subjects stopped responding
            if sum(data(s).exp(f).a == -1) > 20
                flag(s) = sum(data(s).exp(f).a == -1);
            else
                flag(s) = 0;
            end

            % if subjects jam same action over and over
            for c = unique(data(s).exp(f).cond)'
                id = data(s).exp(f).cond==c;
                if std(data(s).exp(f).a(id))<0.1
                    flag(s) = 1;
                end
            end
        end % for each subject

        %data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');
    case 'test3'

        folder = {'experiment/exp4/data/'};
        savepath = 'test3.mat';

        subj = {'A34U4186EW0B9X','A2Z6NL0CTXY0ZB','A3CD3C99T8S6ON','AKOAKQ1J9B9ET','A1YDQJXMEUVSY7',...
            'A20X6V1AAXZGNZ','A175PJR0W3LO8I','A3QS96739O5M6F','A2NAKIXS3DVGAA',...
            'A18WSAKX5YN2FB','A2B9OD2O9CJNC0','A3S3WYVCVWW8IZ','AOS2PVHT2HYTL',...
            'A1PRZC0JL283H7','AUZNL6ARA1UEC','A34EHWOYRBL6OZ','ATIVK9XUANIUE',...
            'A3JZ2WCG7JH1Q8','A36PAA8GSL785A','A3LIRS1WMRIP9P',...%'A2PEN75MMUA963',
            'AR1IWBDA7MC86','A13P6LC1SFXYGS','APL2VQM32UG4X','A1IS0218RVG60K'};
        Q.R = {[1 0 0; 0.25 0.5 0.25;0.25 0.25 0.5];
            [1 0 0; 0.25 0.5 0.25;0.25 0.25 0.5]};         % this one is better for the big p(s) exp, same for the other exp

        f = 1;

        for s = 1:length(subj)
            data(s).N = 0;
            T = readtable(strcat(folder{f}, subj{s}));
            A = table2cell(T);
            R = Q(f).R;
            corr = sum(T.r==1);
            incorr = sum(T.r==0);
            data(s).pcorr(f) = corr/(corr+incorr);

            k = 1; reward_cond = []; idx = []; cond = [];
            for i = 1:size(T,1)
                if ~isempty(T.reward_cond{i})
                    reward_cond(:,:,k) = reshape(str2num(T.reward_cond{i}),3,[])';
                    for j = 1:length(R)
                        if isequal(reward_cond(:,:,k),R{j})
                            cond(k) = j;
                        end
                    end
                    idx(k) = i;
                    k = k+1;
                end
            end

            data(s).ID = subj{s};
            data(s).exp(f).N = length(idx);
            data(s).N = data(s).N + data(s).exp(f).N;
            data(s).exp(f).Q = reward_cond;
            %data(s).exp(f).Q_actual = T.reward_cond_actual(idx);


            if any(T.reward_matrix_idx)
                data(s).exp(f).reward_matrix_idx = T.reward_matrix_idx(idx);
            end

            data(s).exp(f).cond = T.cond(idx);

            data(s).exp(f).s = T.s(idx);
            data(s).exp(f).a = T.a(idx);
            data(s).exp(f).r = T.r(idx);
            data(s).exp(f).rt = T.reactionTime(idx);
            for c = 1:2
                for a = 1:3
                    data(s).exp(f).gab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % general action bias? (before remapping)
                end
            end

            data(s).exp(f).gab =  data(s).exp(f).gab./sum(data(s).exp(f).gab,2);


            for c = unique(data(s).exp(f).cond)'
                temp_a = [];
                ix = data(s).exp(f).cond==c;
                if unique(data(s).exp(f).reward_matrix_idx(ix))==2
                    real_a = [2 3 1];
                elseif unique(data(s).exp(f).reward_matrix_idx(ix))==3
                    real_a = [3 1 2];
                else
                    real_a = [1 2 3];
                end

                % reassign actions
                for a = 1:3
                    temp_a(data(s).exp(f).a(ix)==a) = real_a(a);
                end
                temp_a(data(s).exp(f).a(ix)==-1) = -1;
                data(s).exp(f).a(ix) = temp_a';
            end % for each condition


            for c = 1:2
                for a = 1:3
                    data(s).exp(f).sab(c,a) = sum(data(s).exp(f).a(data(s).exp(f).cond==c)==a); % subjective action bias? (after remapping)
                end
            end
            data(s).exp(f).sab = data(s).exp(f).sab./sum(data(s).exp(f).sab,2);

            for c = 1:2
                ic = data(s).exp(f).cond == c;
                for ss = 1:3
                    for a = 1:3
                        temp(ss,a) = sum(data(s).exp(f).s(ic)==ss & data(s).exp(f).a(ic)==a);
                    end
                end
                data(s).exp(f).pas(:,:,c) = temp;
            end


            % if subjects stopped responding
            if sum(data(s).exp(f).a == -1) > 20
                flag(s) = sum(data(s).exp(f).a == -1);
            else
                flag(s) = 0;
            end
            % if subjects jam same action over and over
            for c = unique(data(s).exp(f).cond)'
                id = data(s).exp(f).cond==c;
                if std(data(s).exp(f).a(id))<0.2
                    flag(s) = 1;
                end
            end
        end % for each subject

        data = data(flag<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data = data(mean(performance,2)>mean(performance(:)));
        save('test3_hp.mat', 'data');

end % switch
end % function