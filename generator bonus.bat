@Echo Off
@setlocal enableextensions enabledelayedexpansion
@echo.
rem Генеатор промокодов
call :generator

rem Ручной ввод
rem set /p promokod=Vvedite PROmoKOD^>
set /a yslovie=0
rem Разбиваем значение на отдельные символы
rem Формируем пары в массив
rem set /a n=
set /a nn=1
 :#2
 @for %%a in ("!promokod:~%n%,1!") do if not "%%~a"=="" set /a n+=1& set /a nn+=1& set /a promokod!n!=%%~a & set /a para%n%=!promokod%n%!*10+!promokod%nn%!& goto #2
rem Проверяем первое условие
rem Колво возможных пар 7
set /a v=1
set /a vv=8
set /a pervoe=0
 :#3
rem Первая цифра
	 if !para%v%! gtr 10 set /a iValue = !para%v%:~0,1! %% 2
	 if !para%v%! lss 10 set /a iValue = 0
rem Число целиком
	set /a Value = !para%v%! %% 2
rem проверяем четность двух цифр и исключаем 0
	if %iValue% neq 0 if %Value% neq 0 (
	set /a pervoe=%pervoe%*10+%v%
rem Дополнительный скачек чтобы исключить смежные пары
	set /a v+=2
rem Для печати конкретных пар которые прошли 1ое условие 
	set "paranechet=%paranechet% !para%v%!"
	)
set /a v+=1
if %v% LSS %vv% goto #3
rem set /a cnt =0
For %%d In (14 15 16 17 25 26 27 36 37 47 147) do ( 
	if %pervoe% equ %%d ( 
	set /a yslovie=1
rem Проверка второго условия если первое верно
	call :proverka2
	))
rem Проверка по приоритету 2го и 1го из условий
For %%d In (2 1 3 4) do if %yslovie% equ %%d goto #end

rem Проверка 3го условия если 1 и 2 неверно
set /a nechet=0
set /a chet=0
for /l %%i in (1, 1, 8) do (
if !promokod%%i! neq 0 (
	set /a iValue = !promokod%%i! %% 2
	
	if !iValue! equ 0  (
	set /a chet=!chet!+!promokod%%i! 
	) else (
	set /a nechet=!nechet!+!promokod%%i!
	)))
if %chet% gtr %nechet% (
echo %promokod% 100 Bonus chet-%chet% nechet-%nechet% 
) else (
echo %promokod% Promokod Empty chet-%chet% nechet-%nechet% 
)
:#end
pause>nul
endlocal
exit
rem 78215037
rem 97995228
rem 48183276 chet 28 (в примере ошибка указано 20, но там 28)

----------------
:proverka2
rem Проверяем Второе условие только если первое верно
set /a v=1
set /a vv=8
set /a vtoroe=0
set /a vtoroe2=0
set "paranechet2="
:#proverka2
rem Первая цифра чет/нечет
	set /a iValue = !para%v%:~0,1! %% 2
rem Первая цифра
	set /a iValue1 = !para%v%:~0,1!
rem Вторая цифра
	set /a iValue2 = !para%v%:~1,1! 
rem Число целиком чет/нечет
	set /a Value = !para%v%! %% 2
rem проверяем четность двух цифр и исключаем 0
if %iValue% neq 0 if %Value% neq 0 if !para%v%! gtr 10 ( 
set /a vtoroe=%vtoroe%*10+%v%
)
rem Проверяем четность двух цифр исключаем 0, а также сравниваем перое и второе число пары, две проверки должны совпасть для получения бонуса в 2000
if !iValue! neq 0 if !Value! neq 0 if !para%v%! gtr 10 if !iValue1! lss !iValue2! (
set /a vtoroe2=!vtoroe2!*10+!v!
rem Для печати конкретных пар которые прошли 2ое условие
set "paranechet2=%paranechet2% !para%v%!"
)
set /a v+=1
rem Вторая проверка
if %v% LSS %vv% goto #proverka2 
if %vtoroe% equ %vtoroe2% ( 
	set /a yslovie=2
	echo %promokod% 2000 Bonus para%paranechet2%
 ) else ( 
	set /a yslovie=1
	echo %promokod% 1000 Bonus para%paranechet%
 )
exit /b
----------------
:generator
rem Генератор промокода
set "promokod="
For %%d In (0 1 2 3 4 5 6 7 8 9) Do Set /a cnt +=1& Set d[!cnt!]=%%d
set /A v=0
rem Колво символов в промокоде
set /A vv=8
:#generator
set /A MIN=1
set /A MAX=10
set /A SEED=%RANDOM%
rem  случайное число
set /A tt=%MIN%+%SEED%-(%SEED%/(%MAX%-%MIN%+1))*(%MAX%-%MIN%+1)
set "promokod%v%=!d[%tt%]!"
set "promokod=%promokod%%promokod!v!%"
set /A v+=1
if !v! LSS !vv! goto #generator
rem Перевод в строку
set "promokod="
for /L %%i in (0,1,%vv%) do set "promokod=!promokod!!promokod%%i!"
echo %promokod%
exit /b
----------------