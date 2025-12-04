% =========================================================================
% Pregunta 6: Filtro pasabajos de segundo orden para filtrar señal a 120Hz
% =========================================================================

clear all; close all; clc;

%% Especificaciones del filtro
f_señal = 120;                   % Frecuencia a filtrar: 120 Hz
w_señal = 2*pi*f_señal;          % Frecuencia angular: 754 rad/s

% Seleccionamos frecuencia natural una década debajo
wn = 2*pi*12;                    % Frecuencia natural: 12 Hz (75.4 rad/s)
zeta = 0.707;                    % Factor de amortiguamiento (Butterworth)

fprintf('=== FILTRO PASABAJOS DE SEGUNDO ORDEN ===\n');
fprintf('Frecuencia natural: %.2f Hz (%.2f rad/s)\n', wn/(2*pi), wn);
fprintf('Factor de amortiguamiento: %.3f\n', zeta);
fprintf('Frecuencia a atenuar: %.2f Hz (%.2f rad/s)\n\n', f_señal, w_señal);

%% Función de transferencia: H(s) = wn² / (s² + 2*zeta*wn*s + wn²)
num = [wn^2];
den = [1 2*zeta*wn wn^2];
H = tf(num, den);

fprintf('Función de transferencia:\n');
display(H);

%% Respuesta en frecuencia H(jω)
w = logspace(-1, 4, 1000);
[mag, phase] = bode(H, w);
mag = squeeze(mag);
phase = squeeze(phase);

% Convertir magnitud a dB
mag_dB = 20*log10(mag);

fprintf('Atenuación a 120 Hz: %.2f dB\n', mag_dB(find(w >= w_señal, 1)));

%% Polos del sistema
polos = pole(H);
fprintf('\n=== POLOS DEL SISTEMA ===\n');
fprintf('Polo 1: %.4f %+.4fi\n', real(polos(1)), imag(polos(1)));
fprintf('Polo 2: %.4f %+.4fi\n', real(polos(2)), imag(polos(2)));

%% Respuesta impulsiva h(t)
t = linspace(0, 1, 1000);
h_t = impulse(H, t);

% Forma analítica (para zeta < 1, subamortiguado)
wd = wn * sqrt(1 - zeta^2);      % Frecuencia natural amortiguada
h_analitica = (wn/sqrt(1-zeta^2)) * exp(-zeta*wn*t) .* sin(wd*t);

fprintf('\nRespuesta impulsiva (subamortiguada):\n');
fprintf('h(t) = (wn/sqrt(1-ζ²)) * exp(-ζ*wn*t) * sin(wd*t) * u(t)\n');
fprintf('donde wd = wn*sqrt(1-ζ²) = %.2f rad/s\n', wd);

%% Respuesta al paso s(t)
s_t = step(H, t);

fprintf('\nRespuesta al paso:\n');
fprintf('s(t) = 1 - exp(-ζ*wn*t) * [cos(wd*t) + (ζ/sqrt(1-ζ²))*sin(wd*t)] * u(t)\n');

%% Diagrama de Bode
figure('Position', [100, 100, 1200, 500]);

subplot(2,1,1);
semilogx(w/(2*pi), mag_dB, 'b', 'LineWidth', 1.5);
hold on;
semilogx([wn/(2*pi) wn/(2*pi)], [-120 10], 'r--', 'LineWidth', 1);
semilogx([f_señal f_señal], [-120 10], 'g--', 'LineWidth', 1);
% Línea de pendiente -40 dB/dec
w_ref = wn;
mag_ref = 0;
w_asint = logspace(log10(wn/(2*pi)), 3, 100);
asintota = mag_ref - 40*log10(w_asint/(wn/(2*pi)));
semilogx(w_asint, asintota, 'k--', 'LineWidth', 1);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud');
legend('|H(j\omega)|', sprintf('fn = %.1f Hz', wn/(2*pi)), ...
       sprintf('f_{señal} = %.1f Hz', f_señal), '-40 dB/dec');
ylim([-120 10]);

subplot(2,1,2);
semilogx(w/(2*pi), phase, 'b', 'LineWidth', 1.5);
hold on;
semilogx([wn/(2*pi) wn/(2*pi)], [-200 10], 'r--', 'LineWidth', 1);
semilogx([f_señal f_señal], [-200 10], 'g--', 'LineWidth', 1);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (grados)');
title('Diagrama de Bode - Fase');
legend('\angle H(j\omega)', sprintf('fn = %.1f Hz', wn/(2*pi)), ...
       sprintf('f_{señal} = %.1f Hz', f_señal));
ylim([-200 10]);

saveas(gcf, 'bode_segundo_orden_120Hz.png');

%% Respuestas en el tiempo
figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t, h_t, 'b', 'LineWidth', 1.5);
hold on;
plot(t, h_analitica, 'r--', 'LineWidth', 1);
grid on;
xlabel('Tiempo (s)');
ylabel('h(t)');
title('Respuesta Impulsiva');
legend('Simulación', 'Analítica');

subplot(1,2,2);
plot(t, s_t, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (s)');
ylabel('s(t)');
title('Respuesta al Paso');

saveas(gcf, 'respuestas_tiempo_segundo_orden_120Hz.png');

%% Diagrama de polos y ceros
figure('Position', [100, 100, 600, 500]);
pzmap(H);
grid on;
title('Diagrama de Polos y Ceros');
saveas(gcf, 'polos_ceros_segundo_orden.png');

%% Análisis de estabilidad
fprintf('\n=== ANÁLISIS DE ESTABILIDAD Y CAUSALIDAD ===\n');
fprintf('Parte real de los polos: %.4f\n', real(polos(1)));
if all(real(polos) < 0)
    fprintf('Sistema ESTABLE (todos los polos en semiplano izquierdo)\n');
else
    fprintf('Sistema INESTABLE\n');
end
fprintf('Sistema CAUSAL (filtro realizable físicamente)\n');

%% Parámetros de desempeño
info_step = stepinfo(H);
fprintf('\n=== PARÁMETROS DE DESEMPEÑO ===\n');
fprintf('Tiempo de establecimiento (2%%): %.4f s\n', info_step.SettlingTime);
fprintf('Tiempo de subida: %.4f s\n', info_step.RiseTime);
fprintf('Sobreimpulso: %.2f %%\n', info_step.Overshoot);
fprintf('Tiempo pico: %.4f s\n', info_step.PeakTime);

fprintf('\n=== EQUIVALENCIAS ===\n');
fprintf('Sistema eléctrico RLC (serie):\n');
fprintf('  - Ecuación: L*d²i/dt² + R*di/dt + (1/C)*i = (1/C)*v(t)\n');
fprintf('  - wn = 1/sqrt(LC) = %.2f rad/s\n', wn);
fprintf('  - 2*ζ*wn = R/L = %.2f\n', 2*zeta*wn);
fprintf('  - Si L = 1 H, entonces C = %.2e F, R = %.2f Ω\n', 1/wn^2, 2*zeta*wn);

fprintf('\nSistema mecánico masa-resorte-amortiguador:\n');
fprintf('  - Ecuación: M*d²x/dt² + B*dx/dt + K*x = K*u(t)\n');
fprintf('  - wn = sqrt(K/M) = %.2f rad/s\n', wn);
fprintf('  - 2*ζ*wn = B/M = %.2f\n', 2*zeta*wn);
fprintf('  - Si M = 1 kg, entonces K = %.2f N/m, B = %.2f N·s/m\n', wn^2, 2*zeta*wn);

fprintf('\nArchivos generados exitosamente.\n');
