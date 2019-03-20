function results = run_MKCFup(seq, res_path, bSaveImage)

params.debug = 0;
params.gap = 6;

params.learning_rate_cn_color = 0.0174;
params.learning_rate_cn_gray = 0.0175;
params.learning_rate_hog_color = 0.0173;%0.0175(for OTB100)
params.learning_rate_hog_gray = 0.018;
params.num_compressed_dim_cn = 4;
params.num_compressed_dim_hog = 4;
%parameters according to the paper
params.padding = 1.5;                       % extra area surrounding the target
params.output_sigma_factor = 1/16;          % spatial bandwidth (proportional to target)
params.scale_sigma_factor = 1/16;           % standard deviation for the desired scale filter output
params.lambda = 1e-2;                       %  Scale regularization (denoted "lambda" in the paper)
params.interp_factor = 0.025;               % tracking model learning rate (denoted "eta" in the paper)
params.cn_features = {'cn10'};              % features that atranslation_vec = [trans_row, trans_col] .* (img_support_sz./output_sz) * currentScaleFactor * scaleFactors(scale_ind);re not compressed, a cell with strings (possible choices: 'gray', 'cn')
params.hog_features = {'hog'};              % features that are compressed, a cell with strings (possible choices: 'gray', 'cn')

params.cnSigma_color = 0.515;
params.hogSigma_color = 0.6;

params.cnSigma_gray = 0.3;
params.hogSigma_gray = 0.4;
params.refinement_iterations = 1;           % number of iterations used to refine the resulting position in a frame
params.translation_model_max_area = inf;    % maximum area of the translation model
params.interpolate_response = 1;            % interpolation method for the translation scores
params.lamda=0.01;
params.number_of_scales = 20;               % number of scale levels
params.number_of_interp_scales = 39;        % number of scale levels after interpolation
params.scale_model_factor = 1.0;            % relative size of the scale sample
params.scale_step = 1.02;                   % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;          % the maximum size of scale examples
params.s_num_compressed_dim = 'MAX';        % number of compressed scale feature dimensions'MAX'
params.visualization = 1;
    
%running in benchmark mode - this is meant to interface easily with the benchmark's code.
seq = evalin('base', 'subS');
target_sz = seq.init_rect(1,[4,3]);
pos = seq.init_rect(1,[2,1])+ floor(target_sz/2);
img_files = seq.s_frames;
video_path = [];

params.init_pos = pos;
params.wsize = floor(target_sz);
params.img_files = img_files;
params.video_path = video_path;

[positions, fps] = MKCF_tracker(params);

rects = positions;
position(:,1) = rects(:,2)-floor(rects(:,4)/2);
position(:,2) = rects(:,1)-floor(rects(:,3)/2);
position(:,3) = rects(:,4);
position(:,4) = rects(:,3);

results.type = 'rect';
results.res = position;
results.fps = fps;
disp(['fps: ' num2str(fps)])
