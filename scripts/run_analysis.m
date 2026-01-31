%% JUSTIFICATION 
format short g % for formatting of results
% Initializing TF num and den
Gs_num = [1.26 27.86 52734.82]
Gs_den = [1.47 112.27 38552.43 50915.38]
[A,B,C,D] = tf2ss(Gs_num, Gs_den)
% Controllability matrix
CO = ctrb(A,B)
% Checking rank of CO 
CO_rank = rank(CO)
% Checking determinant of CO
CO_det = det(CO)

% Observability matrix
OB = obsv(A,C)
OB_rank = rank(OB)
OB_det = det(OB)

% Stability analysis
Gs = tf([Gs_num],[Gs_den])
poles = pole(Gs);
zeros = zero(Gs);

disp('Poles of Gs:');
disp(poles);

disp('Zeros of Gs:');
disp(zeros);
pzmap(Gs)

%% PART- B, REVIEW, ANALYSIS AND SIMULATION
%% ANALYSIS
% PID gain values
kp = 217.3
ki = 4344.6
kd = 5.0314

% CLTF calculation
Cs= tf([kd kp ki],[1 0])
Ts = feedback(Gs, Cs)

%Poles of CLTF
CLTFpoles=pole(Ts)
pzmap(Ts)

% Initializing OLTF for bode plot
OLTF = series(Gs, Cs)
nyquist(OLTF)

% Poles, zeros and eigenvalues of CLTF
poles=pole(Ts)
zeros=zero(Ts)
CLTF_ss=ss(Ts);
eigenvalues=eig(CLTF_ss)

%bode plotof CLTF
bode(Ts)

%% SIMULATION
%% Uncompensated system step response
Gs = tf([1.26 27.86 52734.82], ...
    [1.47 112.27 38552.43 50915.38])
%tstop = 10
%sim('UNCOMPENSATED')
%save('UNCOMPENSATED.mat', 'tout', 'yout');
load('UNCOMPENSATED.mat');
plot(tout, yout);  
title('Uncompensated System Response');
xlabel('Time (s)');
ylabel('Output Value');
grid on;

%% Compensated system step response
CsGs = series(Gs, Cs)
%tstop = 10
%sim('COMPENSATED')
%save('COMPENSATED.mat', 'tout', 'yout1'); 
load('COMPENSATED.mat');
plot(tout, yout1);  
title('Compensated ystem Response');
xlabel('Time (s)');
ylabel('Output Value');
grid on;
%% Performance metrics of compensated step response
% Steady-state value
y_ss = yout1(end); % last value of yout1

% Percent Overshoot
y_max = max(yout1); % max value of the response
PO = ((y_max - y_ss) / y_ss) * 100;

% Settling Time
settling_idx = find(abs(yout1 - y_ss) <= 0.02 * y_ss, 1, 'first');
t_s = tout(settling_idx); % Time when response stays within 2% of ss

% Rise Time 
t_r_10 = find(yout1 >= 0.1 * y_ss, 1, 'first'); % When reaches 10% of ss 
t_r_90 = find(yout1 >= 0.9 * y_ss, 1, 'first'); % When reaches 90% of ss
t_r = tout(t_r_90) - tout(t_r_10); % Difference between 90% and 10%

% Peak Time
[~, peak_idx] = max(yout1); % Index of the peak value
t_p = tout(peak_idx); % Time of first peak

% Steady-State Error
desired_value = 1; 
E_ss = y_ss - desired_value;

% Display Results
disp(['Percent Overshoot: ', num2str(PO), '%']);
disp(['Settling Time: ', num2str(t_s), ' s']);
disp(['Rise Time: ', num2str(t_r), 's']);
disp(['Peak Time: ', num2str(t_p), 's']);
disp(['Steady-State Error: ', num2str(E_ss)]);


%% Robustness test
%tstop=3 % set to 3s to focus more on the disturbance
%sim('ROBUSTNESS')
%save('ROBUSTNESS.mat', 'tout', 'yout2');  
load('ROBUSTNESS.mat');
plot(tout, yout2);
title('Robustness Analysis');
xlabel('Time (s)');
ylabel('Output Value');
grid on;