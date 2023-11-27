function data = analyze_rawdata0(experiment)

%{
    Analyze raw jsPsych experiment data saved in .csv files

    USAGE:
        data = analyze_rawdata('data')
%}

prettyplot;

switch experiment
    case 'bonus'
        folder = {'experiment/exp1/data/','experiment/exp2/data/','experiment/exp3/data/','experiment/exp4/data/'};
        folder = {'experiment/exp1/data/','experiment/exp3/data/','experiment/exp4/data/'};
        %folder = {'experiment/test/data/'}
       
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

    case 'data'
        folder = {'experiment/exp4/data/','experiment/exp1/data/','experiment/exp3/data/'};
        survey_folder = 'experiment/survey/';
        savepath = 'data_final.mat';

        subj1 = {'A3V2XCDF45VN9X','A1KIL2V6SMJBGX','AA1IM0SAQ3XFM','A2IP3ZAFYGV8M9',...
            'A3RUL1OC4CAINK','ABBZGF22NICO7','AH1GZQFB3F9NH','A1ATL3G98SFW4V',...
            'A1PRZC0JL283H7','AZ5ZYUCAQ0XDL','A14LOABUGAITBM','A1KAOUCQHCB3WV',...
            'A2PUL3ZDXOW0VZ','A16E8BQLG16N3F','A3L2VS3998R77L','A2U8IBLKZ3K6AY',...
            'A1IGMCPVC4D7UL','A32K4W6B31XWVR','A1YFLIT0E5OJG4','A193SP8INHA4MB',...
            'A1F6MWP9A0XLJQ','A7ERZELTAMWL5','A1DXGBSF4E3WTI','A3NXT3OVGL7QNR',...
            'A1DT7XOW0ISK0K','A2NR6DBUEXC3Y4'}; % landing1.html
        length(subj1)

        subj2 = {'A41APS6V2Z1FJ','A2Z6NL0CTXY0ZB','A38DHLB88V8DL8','AZNIEFUIVB2H0',...
            'A2ZL5GAZK6S0H1','A2AAFWAAS9C1QC','AU849EHZNGV2Z','A1K8QNLYYYX21W',...
            'AEW3RUARJ1K8R','AFK9ALQK5GPNG','A3AHD1NV5XCOF','A3R5OJR60C6004',...
            'A2N4DD7IS7EI2D','AN7B5L7H2UEUK','A90G0G4SJ26BM','AH7Z2M3KSQ4DW',...
            'A3NRIEMOJVVX4A','A16335MOISDG1F','A1BWS5AD2T4NIR','A3FSDH6HUZPNQ8'};  % landing2.html
 length(subj2)

        subj3 = {'A3V2XCDF45VN9X','A3CT8UTPVYUL04','A1ROEDVMTO9Y3X',...
            'AYLYY6ANK0URM','ALNPW5WIO0I','A598UDLZZZAJ3',...
            'A14LOABUGAITBM','A24MNMHSFYW6B','A3VL1CBZ3BGQK7','AHKYVHP6591H8',...
            'A1P6OXEJ86HQRM','AJ7MWBQFNH3E4','AN1JWYDJH4VQR','AU34T9OMHN4Z4',...
            'A2196WCNDZULFS','A1VBP1RMKGUXB','A1BM57TUNAQIXM','A1NIKHUA79SWGD',...
            'A12Q4BP1S02YWS','A39SK1E6IMQBD5','A50K26F2IS94U','AFEPFMO9863WA',...
            'A1SLJKNSNHOJRN','A2YC6PEMIRSOAA','AOS2PVHT2HYTL','A345VDWYMDWTGD',...
            'A2PEN75MMUA963','A34U4186EW0B9X'}; % landing1.html
        %----------------------------------------------------------------------------------------------------%
        subj4 = {'A2AP9F2LCG5GV8','A3774HPOUKYTX7','A3LIRS1WMRIP9P','ACJNWSBIVI46H',...
            'A5CIHEPULDFUF','A32K4W6B31XWVR','A1PNYLOKED8FWF','A3OV174HQJIJK8',...
            'A36W9YOEXLJLBT','ANGJEGCCP3AO2','A13WTEQ06V3B6D','A1K4FKVCBTX1RN',...
            'AMNYS937UWC8M','A1KAOUCQHCB3WV','A2U4JCTILX14EC','A9S6EGIY10U0X',...
            'API17TMVQ2J7Z','A3HVFSD8K94SOR','A32VTF7MS252BR','A10HW8JXM17XLD',...
            'A1YDQJXMEUVSY7','A3JZ2WCG7JH1Q8','AEK2SAEL9GG39','A7VA2Y4H6U31O',...
            'A27LCUA35LPVM8','AS7R0KA3QNVKE','ANOPPPGFNTUPN','A36470UBRH28GO',...
            'A1FKK1Q8C3BAE5','A3V2O71AQ29DRZ'}; % landing3.html N = 30
        subj7 = {'A1Z6RO9XS6SQDD','ALVNMQMD3Q3ZE','A3RTW9UWYKSNWX','A32GQGD6EUJGDJ',...
            'A2RJSGTY72PMVW','A37QFZ8I1TGH2C','A3NOYN845TEJIH','A1VFSNVFK883XU',...
            'AJDHPRCJ985C7','A1MTQP7TA5RCOB','A10FNV58WR3D0G','A2H8COLIKXJRI1',...
            'A2QTL039A5VV3I','A1UBXBFSS3O8K','A28RX7L0QZ993M','A3S5AA4R3RIEEP',...
            'A2HSX08DWDYJU7','A2R75YFKVALBXE','A3OUNEJO97MM8E','A3R71HP45TBQ7O',...
            'AJMXUF6G3KDLP','A31P9Z3VBQM1PB','A3E8SXH0BAYG85','A2JI8LMB1EEQ4Z','A2HAP8SUY3WYKR',...
            'A14W0AXTJ3R19V','A8OGKR1FGWP95','A1NNDQL6TSWQZB','A3F51C49T9A34D',...
            'A1NVJB5O4H7ZCJ','A38TZK07ON180S','A15GLJU2DG7DLO','A1561P9VVA3C1C',...
            'A1F8MH33EFT5VQ','A2APG8MSLJ6G2K','A334VWE4QGAZFR','A3O2D2BUS92BCA','A3L8LSM7V7KX3T'}; % landing3.html N = 40
        subj5 = {'AFHS2E60LZC6X','API17TMVQ2J7Z','AV9GV051TQCZK','AYIECNJJDE14Y',...
            'A3774HPOUKYTX7','AHV4U78TUUDKI','A3DMSP55I880KW','AAY54HW9N8U5K',...
            'A2OWFJJ8YEKBF1','A1K2R6FBPUA5TQ','A2UKIUS36QADNI','AK2XJWYN3PF2V',...
            'ARR3UJTM2ZGK4','A3KIDRWRKC7RI5','AM2KK02JXXW48','A1KD8SJ4EUQT1Q',...
            'ARN8MH7YKZKAZ','A3DG8M8G0L4DNZ','AH7CPLVO15FM5','A37E36IPU0BJX5',...
            'ASQW51PUO2OLI','AIC2D8A9UQO8S','A3N0QZ9ZKUCTCQ','A1UGD2VEVSML1U',...
            'A3ADQ2RLQNJQDU','A2AP9F2LCG5GV8','A3UC9N3EEE6733','A12J4IRF5Z06BT',...
            'A3JZ2WCG7JH1Q8','A3Q6YRWUMALT6D','A1H5TB600ATGFS','APDDA1Y59RHV9',...
            'AKC9H6IX5YCG4','A8EWC86OH91I2','A2FP41BSPG0Y4A','A8V0L2YF8U6OX',...
            'A18WSAKX5YN2FB','A307K1CZXGBN4L','A1E3N1Y6XG1898','A2YCMO8KFFQAJ9',...
            'AK35CJJEYFVYK','A1LRJ4U04532TM','A38YRR6XIUXMRB','AOCZRH4QWLCMF',...
            'A3UJ6WXBW4ZJOV','AMVBT3XDCQBHI','A2T8U68Y44GPVD','A1YDQJXMEUVSY7',...
            'A2IQ0QCTQ3KWLT','A290TNNAJJQCWL','AF0M3066S5UF1','A13FUEPWBCLBUY',...
            'A2QFZ2524HID2B','A2925DTZ2BLK51','A3EA4SHCLJ1UZQ','A3KH1OG87C8DCM',...
            'A3LIRS1WMRIP9P','A2JMEQ3KQFQCRM','AMNYS937UWC8M','A2WAADBO0ZF89K',...
            'A3KH1OG87C8DCM'}; % landing2.html N = 60 'A21QUJTIIAOX2W',
        subj6 = {'A2LPUVK70W6HW1','A13TYYTK5MARJ1','A36FBIDN58N139',...%'A11SDQ8ZAJ8D24'
            'A3W0SCW5UYEB0F','A12EQIULBHM4HJ','AIQM86IRETAJN','A2ELXYKRPPGRPB',...
            'A39C1BN9ZSQ0R2','A1U52239IPV7IO','AJDXSXAWDDAEO','A1DKVUTOBPQH11',...
            'A2X9VV3B0FZKHY','A3TH6B3RUD1MUQ','A1N8TKTLXV92QR','A7QAPZ1YVA0K2',...
            'A11YS0T8MV3Q7C','A33Z6BHAJUGCHY','A25HI5HXUJ0FHF','A26WVAVVE1RM47',...
            'A2M2U7XUBA4CAN','AKNYT1NTK2UFK','A2Z5Q18JHWKCIF','A37OUZOGQKGMW0',...
            'ANK8K5WTHJ61C','A2MUCL20GTQJA0','ACON9O9NMFOHE','A2POU9TTW177VH',...
            'A3RJC9KTQ0U46B','A3ITZNJQUTIZ4C','A2AZYU1CT24O0K','A3BWZ6V34W8SXX',...
            'A8KX1HFH8NE2Q','A30RAYNDOWQ61S',...'AS0REDD6MMWQG','A207MWA5U0GWA5',
            'A3DKM1KM4C4G05','A3R97T5D3RR9JX','A2MJ0X6M3VSFVN','A10QZC063IGNSU',...
            'AZKFSYWVPF6JL','A1T4GVQH4P0BO','A3HL2LL0LEPZT8','A2OU40SUJR40CC',...
            'A2C84QVRK3KG57','A11ST9LLMHHIF9','A1AIMKA54UBYIQ','A2JZTR2ZSALGH4'...
            'A11JGMLOFFPV65','A50NVZ6AI91O','A2PRLCEP7GEQXI',...%'A346UAH34GVOZX',
            'AG1SOUG1P7J76','A1EIKIHK12UDP0','A2OYOBFEQBWPAJ','ACAJFF4MF5S5X',...
            'A3APKUC67F9IMW','A25PT4YG045XLB','A2BABL5AHUOYC7',...%'A1FTJ3XJZM71GI',
            'AS2MFSWNC5CQI','A3IXFZZ3JWTCPW','A3SMOU11PC1TE2','A132GRVDGXPJGY',...
            'AVHCKUAE3WDZM','A336V7IY38Q2WN','A2S6QOCFC3EAYH','A276XK6HT76JZA',...
            'A3NMU6AVMQ0QDB','A3RCX3IQ8L6HHW','A3UMFQFJ8HE82I'}; % landing1.html N = 70

        %subj = [subj1 subj2 subj3]; % these are still with time limit of 2s on Q3
        subj = [subj1 subj2 subj4(1:end-2) subj5 subj6(40:end) subj7];
        length(subj)

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
                    flag(s,f) = sum(data(s).exp(f).a == -1);
                else
                    flag(s,f) = 0;
                end

                % if subjects jam same action over and over
                for c = unique(data(s).exp(f).cond)'
                    id = data(s).exp(f).cond==c;
                    if std(data(s).exp(f).a(id))<0.1
                        flag(s,f) = 1;
                    end
                end
            end % for each folder / experiment
        end % for each subject

        %data = data(sum(flag,2)<1);
        figure; hold on;
        performance = reshape([data.pcorr],length(folder),[])';
        b = barwitherr(sem(performance,1),mean(performance));
        set(gca,'XTick',[b.XEndPoints]);
        xticklabels({'Exp1','Exp2','Exp3'})

        ylabel('% Accuracy');
        box off; set(gcf,'Position',[200 200 500 400]);

        save(savepath, 'data');

        data_hp = data(mean(performance,2)>mean(performance(:)));
        save('data_hp.mat', 'data_hp');

        data_lp = data(mean(performance,2)<mean(performance(:)));
        save('data_lp.mat', 'data_lp');

end % switch
end % function