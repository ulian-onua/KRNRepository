#include <iostream>
#include <windows.h>
#include <ctime>
#include <string>

using namespace std;

const int height = 10; // длина игрового поля (в клетках)
const int width = 10; // ширина игрового поля (в клетках)

typedef struct {
	COORD size,   // размер клеток
		  start;  // координаты начала вывода на экран доски (левая верхняя точка)
	int text_attr[2]; // атрибуты цвета клеток
} board; // структура доски Морского боя

typedef int ship_field[height][width]; // тип - поле для морского боя
enum ship_sort {one_decker = 1, two_decker, three_decker, four_decker}; // тип корабля - (однопалубный, двухпалубный, трехпалубный, четырех палубный)

 
             /* структура, которая отвечает за состояние частицы корабля или целого корабля, если это однопалубный*/
typedef struct
{
	 COORD coords; // одна пара координат для хранения положения частицы корабля или целого корабля, если это однопалубный
	 bool alive; // переменная, которая отвечает за то: жива ли данная ячейка корабля. Имеет true, если ячейка жива.
} ship_coordinates;

enum turning_side_type {horizontal = 0, vertical}; // перечислимый тип, который отвечает за расположение корабля (горизонтальное, вертикальное)

            
                                   /* структура, которая хранит состояние и координаты корабля любого типа */
typedef struct
{
	ship_sort sort; // вид корабля
	bool alive; // переменная, которая отвечает за то, жив ли данный корабль. Имеет true, если он жив.
	turning_side_type ship_side; // переменная, которая отвечает за расположение корабля (горизонтальное, вертикальное)
	union
	{
		ship_coordinates one_d_ship;        // однопалубный корабль
		ship_coordinates two_d_ship[2];     // двухпалубный корабль
		ship_coordinates three_d_ship[3];   // трехпалубный корабль
		ship_coordinates four_d_ship[4];    // четырехпалубный корабль
	}; 
} ship_type;

typedef ship_type ships_type[10]; // все корабли конкретного игрока

typedef struct { int x1, y1, x2, y2;} coords; // координаты прямоугольной фигуры

typedef COORD moves_type[100]; // массив такого типа будет хранить все возможные ходы

typedef struct 
{ 
	COORD arr[3];   // массив удачных ходов, их не может быть более трех
	int num_of_moves; // кол-во удачных ходов
}   lucky_moves_struct; // структура удачных ходов


enum game_status {game, pc_win, user_win}; // перечислимый тип, который отвечает за состояние текущей игры (продолжать игру, комп выиграл, пользователь выиграл)
enum player_type {user = 0, pc}; // перечислимый тип, который отвечает за то, чей ход текущий  (пользователя или компьютера)

enum move_result_type {miss_shot, destroyed_shot}; // результат хода -(мимо, попадание)

const HANDLE output = GetStdHandle(STD_OUTPUT_HANDLE); // дескриптор вывода
const HANDLE input = GetStdHandle(STD_INPUT_HANDLE);   // дескриптор ввода

const int EMPTY = 0; // пустая клетка
const int SHIP_PART = 1; // клетка, на которой находится часть корабля или один корабль
const int AREA_NEAR_SHIP = 2; // клетки возле корабля, на которые нельзя ставить другие корабли
const int MISS = 3; // клетка в которую был сделан выстрел и на которой ничего нет
const int DESTROYED = 4; // клетка, в которую был сделан выстрел и на которой была уничтожена часть корабля
const int AREA_NEAR_DESTROYED = 5; // клетки возле уничтоженного корабля

const coords win_message_coords = {5, 22, 69, 24}; // координаты кона сообщений
const coords hello_window_coords = {10, 3, 60, 20}; // координаты окна приветствия

const SCREEN_COLOR = 2 * 16; // цвет фона окна
const SELECT_COLOR = 4 * 16; // цвет выделенной клетки

const user_ships_color = 14;
const comp_ships_color = 11;

const comp_shot_color = 9;



enum move_side {to_right = 0, to_down, to_left, to_up}; // перечислимый тип, который отвечает за сторону, в которую мы двигаем корабль

/* ................................ПРОТОТИПЫ ФУНКЦИЙ..................................*/


/*.................................Функции, отвечающие за логику игры................................*/


/*add_coords_to_ship_coordinates(...)
  функция присваивает координаты из массива element координатам корабля,
  ship - корабль, координатам которого нужно присвоить другие
  *element - указатель на структуру типа COORD, которая содержит координаты
  */
void add_coords_to_ship_coordinates(ship_type &ship, COORD *element); 

 /* add_ship_element_to_field(...)
	функция добавляет отдельный элемент корабля на поле,
	   при этом она добавляет площадь возле корабля.
	   Клетка, на которую ставится корабль не проверяется на значение, а
	   только на принадлежность полю.
		    field - поле для Морского боя
		   coordinates - координаты элемента корабля
	   Возвращает true, если элемент был успешно поставлен.
	     false, если клетка за пределами поля.*/
bool add_ship_element_to_field (ship_field field, COORD ship_coordinates);

 /* add_ship_to_field (...)
		Функция ставит корабль на поле.
		field - поле, на которое нужно поставить.
		ship - корабль, который нужно поставить
			*/

bool add_ship_to_field (ship_field field, ship_type& ship);

/*	add_to_coords (...)
	функция добавляет к element - added, где
      element - указатель на первый элемент массива COORD 
	  added - указатель на первый элемент массива COORD 
	  int x - кол-во элементов в обоих  массивах.
	  Если x <= 0, то функция возращает false, иначе true
	  */
bool add_to_coords (COORD* element, const COORD *added, int x);

/* add_value_to_field(...)
	Данная функция добавляет значение на определенную клетку поля для Морского боя.
     field - поле
	 value - значение которое надо добавить,
	 coordinates - координаты поля, на которые надо добавить значение.
	 Данная функция, возвращает true, если coordinates указывает на координаты в пределах поля
	 и значение успешно было добавлено. Если coordinates за пределами поля, то false*/
bool add_value_to_field (ship_field field, const int value, const COORD coordinates);

       /*check_all_moves()
	    функция проверяет все возможные "правильные" ходы на определенном поле и закидывает их в массив moves.
			field - поле, на котором проверяеются ходы.
			moves - массив с ходами
			num_of_moves - количество ходов.
			Данная функция используется компьютером.
			"Правильность" хода означает то, он заранее не бессмысленный. Например бессмысленно ходить на клетку
				рядом со сбитым кораблем.*/
bool check_all_moves (ship_field field, moves_type moves, int &num_of_moves);

      /* функция проверяет, пусто ли место, куда мы хотим поставить корабль.
			Возвращает true, если место пусто и на это место можно поставить корабль, иначе false.
			field - поле для Морского боя
			ship - корабль, который мы хотим поставить*/
bool check_field_for_empty(ship_field field, ship_type ship);

/* bool check_if_not_value_in_field(...)
			Данная функция проверяет, нет ли такого значения в определенном месте поле.
		 field - поле, которое нужно проверить
		 value - проверяемое значение
		 coordinates - координаты поля
         Вовзращает true, если такого значения нет.
		 Вовзращает false 1) если есть такое значение
		                  2) если координаты - за пределами поля
						  */
       
bool check_if_not_value_in_field (ship_field field, const int value, const COORD coordinates);

/* ship_type* check_move(...);
	Функция проверяет ход, сделанный пользователем и выполняет определенные логические действия.
	Возвращает указатель на подбитый корабль; если выстрел был сделан мимо, то возвращает 0.
	move_coords - координаты хода
	field - поле для Морского боя, где был сделан ход
	enemy_ships - массив кораблей врага
	player - игрок, для которого выполняет проверка хода.
	*/
ship_type* check_move(COORD move_coords, ship_field field, ships_type &enemy_ships, player_type player);

       /* bool check_move_for_correctness(...)
			данная функция проверяет ход игрока на правильность
			если он уже ходил на ту клетку, то функция возращает true,
			  иначе false.
			  move_coords - координаты хода
			  enemy_field - поле для Морского боя, где был сделан ход*/
bool check_move_for_correctness(const COORD move_coords, const ship_field enemy_field);

 /* bool check_ship_for_all_destroyed(...)
	функция проверяет корабль на полное уничтожение,
      если все его части уничтожены, то функция
		уничтожает весь корабль и возвращает true.
			ship - проверяемый корабль*/
bool check_ship_for_all_destroyed (ship_type &ship);

/* bool check_ship_for_destroyed_parts(...)
		функция проверяет не уничтожен ли какой то элемент корабля,
	         и изменяет структуру корабля (ship), если элемент уничтожен
	        ship - проверяемый корабль
			shot_coords - координаты хода
		Функция воззращает true, если уничтожен элемент корабля, иначе false;
		*/
bool check_ship_for_destroyed_parts (ship_type &ship, COORD shot_coords);

	/* bool check_ship_in_field(
		функция проверяет, находится ли корабль в рамках поля.
		Если корабль в рамках поля, то функция возращает true, иначе false;
		ship - проверяемый корабль */
bool check_ship_in_field(ship_type ship);

 /* check_ship_in_square
	функция проверяет, находится ли корабль в пределах поля, COORD - указатель на первый элемент корабля,
          ship - вид корабля, 
 возвращает true, если корабль в пределах поля, иначе false.
	По результату аналогична функции check*/

bool check_ship_in_square (COORD *element, ship_sort ship);

  /* функция проверяет массив с кораблями на проигрыш.
		Возвращает true, если все корабли уничтожены.
			ships - массив с кораблями*/
bool check_ships_for_loose (const ships_type ships);


 /* check_value_in_square (...)
   Функция проверяет, находится ли элемент с такими координатами в пределах поля.
	Возвращает true, если элемент находится в пределах поля, иначе false;
	element - элемент 
	*/

bool check_value_in_square (const COORD element);

                  /* bool clever_comp_algorithm(...)
					алгоритм умного компьютера. Функция, с помощью которой определяется ход компьютера.
					Если ход был удачным(попали в корабль), то возвращается true, иначе возвращается false.
					enemy_field - поле для Морского боя на котором ходим
					enemy_ships - корабли врага (в нашем случае, пользователя)
					move_coords - координаты хода*/
bool clever_comp_algorithm(ship_field enemy_field, ships_type &enemy_ships, COORD &move_coords);

/* COORD clever_no_lucky_moves(...)
	функция для функции алгоритма умного компьютера clever_comp_algorithm(...)
         Осуществляет действия, если список удачных ходов пуст.
		 enemy_field - поле, на котором ходим
		 enemy_ships - корабли врага
		 lucky_moves - структура удачных ходов.
			Возвращает ход компьютера*/
COORD clever_no_lucky_moves(ship_field enemy_field, ships_type &enemy_ships, lucky_moves_struct &lucky_moves);

/* clever_one_lucky_move(...)
			функция для функции алгоритма умного компьютера
			      осуществляет дествия, если есть один  удачный ход.
				element - удачный ход
				enemy_field - поле дл Морского боя, на котором ходим
				all_clever_moves[] - массив "умных" ходов
				num_of_moves - количество*/

void clever_one_lucky_move(const COORD element, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves);

/*		clever_two_more_moves(...)
			функция для функции алгоритма умного компьютера.
			      Осуществляет дествия, если есть два и более удачных хода.
				lucky_moves - структура удачных ходов
				enemy_field - поле дл Морского боя, на котором ходим
				all_clever_moves[] - массив "умных" ходов
				num_of_moves - количество	*/
void clever_two_more_moves (lucky_moves_struct &lucky_moves, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves);


bool reload();  // функция, которая предлагает сыграть еще раз и возращает true, если пользователь согласился на это.
void set_players(player_type &player1, player_type &player2); // функция случайным образом устанавливает, кто будет игроком1, а кто игроком2.
void do_move(const player_type player); // функция, которая делает ход
void init_ship_coordinates_type (ship_coordinates *ship, int x); // функция для инициализации типа ship_coordinates
void Init_ships_type (ships_type); // функция для начальной инициализации структуры типа ships_type

void comp_ship_placing(ship_field comp_field);


							
	/* функция, которая поворачивает один элемент корабля по горизонтали,
										где turning_element - элемент, который надо повернуть,
												axis - ось  поворота*/
void turn_element_to_horizontal(COORD &turning_element, const COORD axis);
void turn_element_to_vertical (COORD &turning_element, const COORD axis); // функция аналогичная предыдушей, только по-вертикали


				/* функция, которая поворачивает корабль горизонтально или вертикально.
				   Осью поворота служит первый элемент корабля(первый в массиве).
				   COORD coords[] - массив с координатами корабля, i - размер массива.
				   Принимает указатель на функцию, которая содержит алгоритм поворота и поворачивает один элемент корабля.
				   Функция работает для поворота двухпалубных, трехпалубных и четырехпалубных кораблей */;
bool turn_ship (ship_type &ship, int i, turning_side_type turn_side); // функция поворота корабля





/* check_ship_elements_with_value (...)
	Данная функция сравнивает координаты всех элементов корабля с определенным значением на поле Морского боя,
   если все клетки поля с координатами корабля равны этому значению, то функция возвращает true, иначе false.
	 Данная функция используется функцией, которая находит все возможные ходы для двух, трех, четырехпалубных кораблей.
	 field - поле Морского боя
	 *element - указатель на первый элемент корабля
	 ship - вид корабля
	 value - значения с которым сравнивается значение клеток поля
	 */

bool check_ship_elements_with_value (ship_field field, COORD *element, ship_sort ship, int value);






      /* void move_element
		функция, которая перещает отдельный элемент (в данной игре - не обязательно корабля) на поле
	      функция не проверяет, находится ли элемент в пределах поля
		  element_coords - координаты элемента
		  side - сторона, в которую нужно переместить элемент
				*/
void move_element (COORD &element_coords, move_side side);

		/* функция, которая двигает корабль в определенную сторону (вправо, влево, вверх, вниз)
		     *element - указатель на первый элемент корабля, ship - вид корабля,
			 side - сторона, в которую мы двигаем корабль.
              Функция не проверяет, находится ли корабль в пределах поля до движения и после.
              Функция не проверяет также правильно ли "написан" корабль. */

void move_ship (COORD *element, ship_sort ship, move_side side);





 
void get_one_element_for_horizontal (COORD& element, const COORD axis, const int range); // функция находит положение одного элемента корабля относительно оси по горизонтали
void get_one_element_for_vertical (COORD& element, const COORD axis, const int range); // функция находит положение одного элемента корабля относительно оси по вертикали

      /* функция, с помощью которой получаем координаты двух, трех, четырехпалубного корабля в зависимости от оси
     axis (Ось) - первый элемент массива element;
	 ship - тип корабля.
	 turning_side_type - в данной функции используется как позиция корабля(алгоритмы нахождения координат
	корабля для корабля находящегося в горизонтальном положении и вертикальном - разные)
	Функция не проверяет: находится ли ось в пределах поля.
	*/
void get_ship_element_coordinates (COORD *element, ship_sort ship, turning_side_type ship_position); 

           
   /* функция, которая находит все возможные местоположения для однопалубного корабля.
      field - поле для морского боя, на котором нужно искать, 
	  buf[] - массив для хранения возможных местоположений
	  x - размер массив
	  moves_found - кол-во найденных местоположений.
	Функция, возращает true, если найден хотя бы один ход;
	Функция возращает false, если не найден ни одного хода
	или закончилось место в буфере.
	  */

 
bool find_all_one_decker_moves (ship_field field, COORD buf[], int x, int& moves_found); 



  
/* функция находит все возможные местоположения для многопалубного корабля.
        field - поле Морского боя
        buf - буфер, в котором будут храниться координаты возможных положений  
        ship - вид корабля 
         x - размер буфера массива, в котором будут храниться координаты возможных положений
         move_found -  количество местоположений, которое было найдено
        Функция, возращает true, если найдено хотя бы одно местоположение корабля.
         Функция возращает false, если 1) тип корабля - однопалубный
                                2) в буфере меньше одного элемента
                                3) закончилось место в буфере     */

bool find_all_many_decker_moves (ship_field field, COORD *buf, ship_sort ship, int x, int& moves_found);

 
       
   


/* Функция забирает один элемент с поля, т.е. делает ячейку, на которой он стоял пустой,
и делает пустыми соседние ячейки, которые были как поля корабля, только если они не
относятся к другому кораблю */
bool get_element_from_field (ship_field field, COORD ship_coords);

// функция забирает корабль с поля
bool get_ship_from_field(ship_field field, ship_coordinates* ship, int x);
 
 
/* Данная функция "ставит" однопалубный корабль на поле.
       field - поле для Морского боя.
	   ship - однопалубный корабля, который надо поставить.
	   Функция возвращает true, если корабль был успешно поставлен.
	   Возвращает false, 1) если корабль находится за пределами поля
	                     2) если корабль не однопалубный
						 */

bool add_one_decker_to_field (ship_field field, ship_type ship); 




      /* функция возращает положение корабля (горизонтальное, вертикальное) по его координатам 
            Если корабль однопалубный, то возвращает всегда горизонтальное.   */
turning_side_type get_turning_side (ship_type ship);   


         /* Функция случайным образом расставляет корабли на поле.
		    field - поле для Морского боя
			ships - массив с кораблями
			*/
         
void ship_placing(ship_field field, ships_type ships); // функция для случайной расстановки кораблей на поле


      
 

 /*................................. ФУНКЦИИ, ОТВЕЧАЮЩИЕ ЗА ГРАФИКУ ИГРЫ...................*/

void write_field (ship_field field); // выводит поле в текстовом режиме, где field - поле для Морского боя
        
         /* void delete_ship(...)
			Функция удаляет корабль по указанным координатам.
			output - дескриптор вывода
			table - доска в граф. выражении
			start - начальные координаты клетки доски (как координаты экрана) */
void delete_ship (const HANDLE output, board table, COORD start); 
		/* функция выводит на экран квадрат, где output - указатель на устройство вывода, text_attr - атрибут цвета/фона,
	      start - начальная координата вырисовки квадрата (на экране), // size - размер квадрат (x и y) */

bool draw_square(const HANDLE output, const int text_attr, COORD start, COORD size);
bool draw_table (const HANDLE output, board table); // функция рисует доску на экране, где table - структура, характеризующая доску

void draw_window(const HANDLE output, coords Win_Coords,  char title[]); // функция рисует границы окна по заданным координатам и его заголовок
		    /*	void clear_window(...)
			Функция очищает содержимое окна по заданным координатам окна.
			output - дескриптор вывода
			Win_Coords - координаты окна
			*/

void clear_window (const HANDLE output, coords Win_Coords); 
               	/* с помощью этой функции можно получить начальные координаты любой клетки на графической доске,
				  table - доска в граф. выражении,
				  field_coords - координаты клетки как для массива
				  */
COORD GetOffset (const HANDLE output, board table, const COORD field_coords);

                /* функция возвращает координаты клетки как для массиве по координатам на графической доске,
				    в какой то мере обратна функции GetOffset,
					coordinates - координаты на экране
					table - доска в графическом выражении.*/
COORD GetXYbyOffset(COORD coordinates, board table);  
// функция хранит графическое выражение элемента корабля, возвращает его в *stars[] - массив указателей на символ
void ship_stars (char *stars[]);
                   /* функция возвращает цвет клетки доски по заданным координатам
				       table - доска в граф. выражении
					   coordinates - координаты клетки как для массива */
int get_color_index (board table, COORD coordinates);

                   /* функция рисует корабль в указанных координатах доски 
					output - устройство вывода,
					table - доска в граф. выражении
					color - цвет корабля
					start - координаты клетки как массива.
					*/

void draw_at_square(const HANDLE output, board table, int color, COORD start, void (*image)(char*[])); // функция рисует корабль в указанных координатах доски

 /* функция проверяет, находятся ли координаты в пределах доски.
      Вовзращает true, если координаты в пределах доски, иначе false
	   coordinates - проверяемые координаты
         table - доска*/

bool InField (COORD coordinates, board table);

 /* функция проверяет, находятся ли проверяемые координаты в пределах клетки
	 Вовзращает true, если координаты в пределах клетки, иначе false.
	 coords - координаты клетки
	 size - размер клетки
	 check_coords - проверяемые координаты
	 */

bool InSquare (COORD coords, COORD size, COORD check_coords);

		/* функция заливает клетку на доске определенным цветом,
		   необходима для реакцию клеток на наведении на них мышки,
		   coords - координаты клетки как элемента массива
		   table - доска в графическом выражении
		   color - цвет заливки.
		   Вовзращает true, если заливка прошла успешно, иначе false
		   */
		   
bool FillSquare(COORD coords, board table, int color); 

/*..................................ФУНКЦИИ, ОТВЕЧАЮЩИЕ ЗА РАБОТУ С КОНСОЛЬЮ...................*/

/*		ConsoleTitle (...)
		Функция, создает заголовок для окна консоли.
        output - дескриптор вывода(собственно, консоль)
		text[] - строка, которая будет заголовком (можно на русском языке)
		*/
void ConsoleTitle (const HANDLE output, const char text[]);   
							/* функция устанавливает курсор в заданном месте. 
								Сделана с целью упрощения функции 
								SetConsoleCursorPosition ( не нужно создавать переменную типа COORD).*/
void gotoxy (const HANDLE output, const int x, const int y);

     /* void ClearScreen(...)
		Функция заполняет экран (80*25) символами с определенным атрибутами цвета/ фона, где
	           color - атрибуты цвета/ фона
			   sym - символ
			   */
void ClearScreen (int color, char sym);

void HideCursor(HANDLE output); // функция прячет курсор консоли

           
       /*   COORD click_move(...)
			Функция возращает COORD - координаты сделанного щелчка мышкой как элемента массива
	        table - доска в граф. выражении, этот параметр нужен для того, чтобы определить - 
			какие клетки подсвечивать при наведении мыши.
			 */
COORD click_move(board table); // с помощью этой функции делается ход мышкой

/*....................................ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ................................................*/

/*int abs_num(...)
 функция возращает модуль целого числа, где x - целое число, модуль которого нужно возратить */
int abs_num(const int x) { return (x < 0) ? -x : x;} 
/* char_size(...)
Функция возращает размер строки как числовое значение.
char x[] - строка
Используется функциями отображения графики.*/
int char_size (char x[]); 
		/*  check_sym_in_array (...)
			функция проверяет, находится ли символ в массиве символов.
			Если символ есть в массиве, то вернуть true, иначе false.
			sym - символ, который проверяем
			arr[] - массив, в котором проверяем*/
bool check_sym_in_array (char sym, char arr[]);

/* void clear_lucky_moves(...)
	функция для очистки структуры типа lucky_moves_struct.
	Присваивает всем элементам данной структуры - 0;
	lucky_moves - структура, которую необходимо очистить.*/
void clear_lucky_moves(lucky_moves_struct &lucky_moves);

/* sort_lucky_moves_by_X(...)
	функция сортирует массив структуры lucky_moves по X.
	Самый меньший элемент располагается в начале массива.
	lucky_moves - структура, которую надо отсортировать
	*/
void sort_lucky_moves_by_X(lucky_moves_struct &lucky_moves);

/* compare_two_COORD(...)
	функция сравнивает две структуры типа Coord,
				возвращает true, если они равны, иначе false
		first - первая структура
		second - вторая структура*/
bool compare_two_COORD(const COORD first, const COORD second);


/*.................................ФУНКЦИИ, ИСПОЛЬЗУЕМЫЕ В ОСНОВНОЙ ЧАСТИ ПРОГРАММЫ */
     /* game_status check_game_status(...)
	 функция проверяет и возвращает состояние игры,
		   user_ships - корабли пользователя
		   comp_ships - корабли компьютера.
		   Если выиграл пользователь, то возвращается user_win,
			 если выиграл компьютер, то возвращается comp_win,
			если никто не выиграл и игру нужно продолжать, то
			  возвращается game
				*/
game_status check_game_status(ships_type user_ships, ships_type comp_ships);
 
/* ................................ОПРЕДЕЛЕНИЯ ФУНКЦИЙ..................................................*/

void swap_two_integers (short &first, short &second)
{
	int temp = first;
	first = second;
	second = temp;
}

	/* функция проверяет, находится ли корабль в рамках поля */
bool check_ship_in_field(ship_type ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		if (!check_value_in_square(ship_p[i].coords))
			return false;
	return true;
}



              
void turn_element_to_horizontal(COORD &turning_element, const COORD axis) // поворот одного элемента по горизонтали
{
	turning_element.Y = turning_element.Y + (turning_element.X - axis.X);
	turning_element.X = axis.X;
}


void turn_element_to_vertical (COORD &turning_element, const COORD axis) // поворот одного элемента по вертикали
{
	turning_element.X = turning_element.X + (turning_element.Y - axis.Y);
	turning_element.Y = axis.Y;

}

bool turn_ship (ship_type &ship, int i, turning_side_type turn_side) // функция поворота корабля
{
		
	
		void (*turn_function) (COORD&, const COORD);  // функция поворота отдельного элемента корабля

		ship_type temp = ship; // временно сохраним
		ship_coordinates *ship_p = &ship.one_d_ship;

		if (turn_side == horizontal) // если поворачивать будем на горизонталь, то присвоим указателям на функции соответству. функции
			turn_function = turn_element_to_horizontal;
		
		else // иначе если поворот на вертикаль
			turn_function = turn_element_to_vertical;
		


		if (i > 1) // если корабль больше однопалубного
	
			// повернем каждый элемент корабля вокруг его оси
			while (--i != 0)
				 turn_function (ship_p[i].coords, ship_p[0].coords); // функция для поворота одного элемента по горизонтали и вертикали

		if (check_ship_in_field(ship))
		{
			
			ship.ship_side = turn_side;
			return true;
		}
		else
		{
			ship = temp;
			return false;
		}
		
	
}

bool check_value_in_square (const COORD element) // функция проверяет, находится ли переменная с таким координтами в пределах доски
{
	return (element.X >= 0 && element.X < height && element.Y >= 0 && element.Y < width);
}


bool check_ship_in_square (COORD *element, ship_sort ship) // функция проверяет, находится ли корабль в пределах доски
{
	for (int i = 0; i < ship; i++)
		if (!(check_value_in_square(element[i])))
			return false;
	return true;
}


void move_element (COORD &element_coords, move_side side)
{

	COORD temp = element_coords;
		switch (side)   // в зависимости от того в какую сторону двигаем, изменяем координаты элеменента
		{
			case to_left:
				element_coords.Y--;
				break;
			case to_right:
				element_coords.Y++;
				break;
			case to_up:
				element_coords.X--;
				break;
			case to_down:
				element_coords.X++;
		}
		if (!check_value_in_square(element_coords))
			element_coords = temp;
}

	


void move_ship (ship_type &ship, move_side side) // функция, которая передвигает корабль в определенную сторону
{
	ship_coordinates *ship_p = &ship.one_d_ship;
	ship_type temp = ship;
	
	for (int i = 0; i < ship.sort; i++) 
		move_element(ship_p[i].coords, side); // двигаем каждый элемент корабля

	if (!check_ship_in_field(ship))
		ship = temp;
}

void get_one_element_for_horizontal (COORD& element, const COORD axis, const int range) // функция находит положение одного элемента корабля относительно оси по горизонтали
{
	element.X = axis.X;
	element.Y = axis.Y + range;
}

void get_one_element_for_vertical (COORD& element, const COORD axis, const int range) // функция находит положение одного элемента корабля относительно оси по вертикали
{
	element.X = axis.X + range;
	element.Y = axis.Y;
}

void get_ship_element_coordinates (COORD *element, ship_sort ship, turning_side_type ship_position) // функция получает элементов корабля в относительно оси корабля, в зависимости от положения корабля
{
	void (*get_one_element_coordinates) (COORD&, const COORD, const int); // указатель на функцию, которая будет находить координаты отдельного элемента относительно оси

	if (ship_position == horizontal) // выбираем функция в зависимости от положения корабля
		get_one_element_coordinates = get_one_element_for_horizontal;
	else
		get_one_element_coordinates = get_one_element_for_vertical;
	
	
	for (int i = 1; i < ship; i++)
		get_one_element_coordinates(element[i], element[0], i);

}

bool find_all_one_decker_moves (ship_field field, COORD buf[], int x, int& moves_found) // найдем все ходы для однопалубного корабля
{
	
	moves_found = 0;
	
	for (int i = 0; i < width; i++)
		for (int i2 = 0; i2 < height; i2++)
			if (field[i][i2] == EMPTY) // если клетка пустая, то на нее можно поставить однопалубный корабль
			{
				buf[moves_found].X = i;
				buf[moves_found].Y = i2;
				moves_found++;
				x--; 
				if (x == 0)
					return false;
			}

	if (moves_found > 0) // если мы нашли хотя бы один ход
		return true;
	return false;
}

 // сравниваем клетки поля с координатами корабля с определенным значением.
bool check_ship_elements_with_value (ship_field field, COORD *element, ship_sort ship, int value)
{
	for (int i = 0; i < ship; i++)
		if (field[element[i].X][element[i].Y] != value)
			return false;
	return true;
}

bool add_to_coords (COORD* element, const COORD *added, int x) // присваивает added массиву element
{
	if (x <= 0)
		return false;
	for (int i = 0; i < x; i++)
		element[i] = added[i];
	return true;
}

void add_coords_to_ship_coordinates (ship_type &ship, COORD *element) // присваивает координаты из массива element переменным типа COORD записи ship_coordinates
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		ship_p[i].coords = element[i];
}


bool find_all_many_decker_moves (ship_field field, COORD *buf, ship_sort ship, int x, int& moves_found) // находим возможные местоположения для любого типа корабля
{
	
	if (ship < two_decker) // если корабль меньше двухпалубного..
		return false;
	if (x < 1)               // если размер буфера меньше 1
		return false;
	
	
	COORD temp[four_decker]; // переменная для хранения координат корабля, ходы для которого мы ищем. Может использоваться для любого типа корабля из многопалубных.
	moves_found = 0; // переменная, которая отвечает за нейденные ходы
	for (int i = 0; i < height; i++)
	{
		
		temp[0].X = i;
		temp[0].Y = 0;
		
		while (check_value_in_square(temp[0]))  // пока первый элемент корабля (ось) в пределах поля
		{
			for (int i2 = horizontal; i2 <= vertical; i2++) // проверяем корабль по горизонтали и вертикали
			{
				get_ship_element_coordinates(temp, ship, turning_side_type(i2)); // получим координаты остальных элементов корабля 
			if (check_ship_in_square(temp, ship))  // если корабль находится в пределах поля              
			if (check_ship_elements_with_value (field, temp, ship, EMPTY)) // если все элементы корабля находятся на пустых клетках поля
			{
				add_to_coords (&buf[moves_found * ship], temp, ship);
				moves_found++;  
				x--;
				if (x = 0) // если в буфере больше нет места
					return false;
            }
			}
			temp[0].Y++;
		}
	}
	
	return (moves_found > 0) ? true : false;
}


bool add_value_to_field (ship_field field, const int value, const COORD coordinates) // добавляет значение на поле
{
	if (check_value_in_square(coordinates)) // если значение в рамках поля
	{
		field[coordinates.X][coordinates.Y] = value; 
		return true;
	}
	return false;
}

bool check_if_not_value_in_field (ship_field field, const int value, const COORD coordinates) // функиция проверяет, нет ли определенного значения на указанных координатах поля
{
	if (check_value_in_square(coordinates)) // если значение  в рамках поля
		if (field[coordinates.X][coordinates.Y] != value)
			return true;
	return false;
}



bool add_ship_element_to_field (ship_field field, COORD ship_coordinates) // добавляет элемент на поле
{
	if (!add_value_to_field(field, SHIP_PART, ship_coordinates))  // добавляем на поле элемент, если не смогли добавить, то возвращаем false
		return false;
	
	COORD temp_square = {ship_coordinates.X - 1, ship_coordinates.Y - 1}; // координаты клетки, с которой мы начинаем проход (левая верхняя)

	for (int i = 0; i < 8; i++) // надо будем пройти восемь клеток
	{
		if (check_value_in_square(ship_coordinates))  // если элемент в рамках 
			if (check_if_not_value_in_field (field, SHIP_PART, temp_square))   // если то место, не занято элементом корабля
				add_value_to_field(field, AREA_NEAR_SHIP, temp_square);  // добавим место возле корабля

		 int current_side = i / 2;      // сторона в которую мы идем (право, вниз, лево, вверх - по часовой стрелке)
		 move_element(temp_square, move_side(current_side)); // проходим
	}

	return true;
}

bool found_ship_near_area (ship_field field, COORD element_coords)     // ищет корабль возле клетки с полем возле корабля, если он найден, то true, иначе false
{
	COORD temp_square = {element_coords.X - 1, element_coords.Y - 1};
	
	for (int i = 0; i < 8; i++) // надо будем пройти восемь клеток
	{
		if (check_value_in_square(temp_square)) // если элемент в рамках поля
			if (field[temp_square.X][temp_square.Y] == SHIP_PART)
				return true;
		int current_side = i / 2;      // сторона в которую мы идем (право, вниз, лево, вверх - по часовой стрелке)
		move_element(temp_square, move_side(current_side)); // проходим
	}
	return false;
}



bool get_element_from_field (ship_field field, COORD ship_coords) // функция забирает элемент с поля ( с целью перемещение)
{
	if (!add_value_to_field(field, EMPTY, ship_coords))  // убираем элемент с поля (присваиваем пустую клетку - его элементу)
		return false;
	
	COORD temp_square = {ship_coords.X - 1, ship_coords.Y - 1};
	for (int i = 0; i < 8; i++) // надо будем пройти восемь клеток
	{
		
		if (check_value_in_square(ship_coords))  // если элемент в рамках поля
			if (!found_ship_near_area(field, temp_square))
					add_value_to_field(field, EMPTY, temp_square);
				int current_side = i / 2;      // сторона в которую мы идем (право, вниз, лево, вверх - по часовой стрелке)
		move_element(temp_square, move_side(current_side)); // проходим
	}

	return true;
}

bool set_area_near_destroyed (ship_field field, COORD ship_coords)
{
	if (!check_value_in_square(ship_coords))
		return false;

		COORD temp_square = {ship_coords.X - 1, ship_coords.Y - 1};
	for (int i = 0; i < 8; i++) // надо будем пройти восемь клеток
	{
		
		if (check_value_in_square(ship_coords))  // если элемент в рамках поля
			if (check_if_not_value_in_field (field, SHIP_PART, temp_square))   // если то место, не занято элементом корабля
				add_value_to_field(field, AREA_NEAR_DESTROYED, temp_square);
			 int current_side = i / 2;      // сторона в которую мы идем (право, вниз, лево, вверх - по часовой стрелке)
		 move_element(temp_square, move_side(current_side)); // проходим
	}

	return true;
}

void set_area_near_ship_destroyed(ship_field field, ship_type ship)
{

	ship_coordinates *ship_p = &ship.one_d_ship;
	
	for (int i = 0; i < ship.sort; i++)
		set_area_near_destroyed (field, ship_p[i].coords);
}



 


bool get_ship_from_field(ship_field field, ship_coordinates* ship, int x) // функция забирает корабль с поля
{
	if (x < 1)
		return false;
	for (int i = 0; i < x; i++)
		get_element_from_field (field, ship[i].coords); // забираем элемент с поля
	    ship[i].coords.X = 0;  // присваиваем нулевые значения его координатам
		ship[i].coords.Y = 0;
	return true;
}




bool add_ship_to_field (ship_field field, ship_type& ship) // добавляет элементы корабля на поле
{
	ship_coordinates *ship_p = &ship.one_d_ship;
	for (int i = 0; i < ship.sort; i++)
		add_ship_element_to_field(field, ship_p[i].coords);
	return true;
}



			/* функция случайным образом устанавливает, кто будет текущим игроком.
                это необходимо для того, чтобы определить,кто будет ходить первым
				возвращает значения игрока, который будет ходить первым. */
player_type set_current_player() 
{
	return (rand() % 2 == 0) ? user : pc;
}

void init_ship_coordinates_type (ship_coordinates *ship, int x) // функция для инициализации типа ship_coordinates
{
	if (x > 0)
		for (int i = 0; i < x; i++)
		{
			ship[i].alive = true;
			ship[i].coords.X = 0;
			ship[i].coords.Y = 0;
		}
}



void Init_ships_type (ships_type ships) // функция для начальной инициализации структуры типа ships_type
{
	for (int i = 0; i < 10; i++)
	{
		switch(i)
		{
		       /* четыре корабля - однопалубные*/
		case 0:
		case 1:
		case 2:
		case 3:
			ships[i].sort = one_decker;
			init_ship_coordinates_type(&ships[i].one_d_ship, one_decker);
			break;
			          /* три корабля - двухпалубные */
		case 4:
		case 5:
		case 6:
			ships[i].sort = two_decker;
			init_ship_coordinates_type(ships[i].two_d_ship, two_decker);
			break;
			          /* два корабля - трехпалубные */
		case 7:
		case 8:
			ships[i].sort = three_decker;
			init_ship_coordinates_type(ships[i].three_d_ship, three_decker);	

			break;
			         /* один корабль - четырехпалубные */
		case 9:
			ships[i].sort = four_decker;
			init_ship_coordinates_type(ships[i].four_d_ship, four_decker);
			break;
		}
	   ships[i].alive = true; // все корабли изначально живые
	  
	}
}


turning_side_type get_turning_side_by_coords (const COORD first, const COORD second)
{
	return (first.X == second.X) ? horizontal : vertical;
}
	


turning_side_type get_turning_side (ship_type ship)   // возвращает расположение корабля по его координатам
{
	if (ship.sort == one_decker) // если корабль однопалубный, то у него - горизонтальное всегда
		return horizontal;
	else // если корабль многопалубный
	{
		ship_coordinates *ship_p = &ship.one_d_ship;
		return get_turning_side_by_coords(ship_p[0].coords, ship_p[1].coords);
	}
}


void ship_placing(ship_field field, ships_type ships) // функция расстановки кораблей
{
      
	int num_found;
	
	 for (int i = 9; i >=0; i--)
	  {
		  switch (ships[i].sort)
		  {
		  case four_decker:
			  {
				  COORD buf[200][4] = {0}; // буфер для хранения возможных положений четырехпалубного корабля
				  find_all_many_decker_moves(field, &buf[0][0], four_decker, 200, num_found); // находим его возможные положения
				  add_coords_to_ship_coordinates(ships[i], buf[rand() % num_found]);
				  break;
			  }
		  case three_decker:
			  {
				  COORD buf[200][3] = {0};
				  find_all_many_decker_moves(field, &buf[0][0], three_decker, 200, num_found); // находим его возможные положения
				  add_coords_to_ship_coordinates(ships[i], buf[rand() % num_found]);
				  break;
			  }
		  case two_decker:
			  {
				  COORD buf[200][2] = {0};
				  find_all_many_decker_moves(field, &buf[0][0], two_decker, 200, num_found); // находим его возможные положения
				  add_coords_to_ship_coordinates(ships[i], buf[rand() % num_found]);
				  break;
			  }
		  case one_decker:
			  {
				  COORD buf[200];
				  find_all_one_decker_moves(field, buf, 200, num_found);
				  add_coords_to_ship_coordinates(ships[i], &buf[rand() % num_found]);
			  }

		  }
		   
		  add_ship_to_field(field, ships[i]);	

		  ships[i].ship_side = get_turning_side(ships[i]);
	 }
}



void write_field (ship_field field)
{
	for (int i = 0; i < width; i++)
	{
		for (int i2 = 0; i2 < height; i2++)
			if (field[i][i2] == 0)
				cout << "."<< " ";
			else
			if (field[i][i2] == 2)
				cout << "* ";
			else
				cout <<field[i][i2] << " ";

		cout << "\n";
	}
	cout << "\n";
}


bool draw_square(const HANDLE output, const int text_attr, COORD start, COORD size) 
	// функция выводит на экран квадрат, где output - указатель на устройство вывода, text_attr - атрибут цвета/фона,
	//  start - начальная координата вырисовки квадрата (на экране), // size - размер квадрат (x и y)
{
	SetConsoleTextAttribute(output, text_attr);
	SetConsoleCursorPosition(output, start);
	int temp_x = size.X;
		 
	while (size.Y-- != 0)
	{
		while (size.X-- != 0)
			cout <<" ";
		size.X = temp_x;
		start.Y++;
		SetConsoleCursorPosition(output, start );
	}
	 return true;
	}

bool draw_table (const HANDLE output, board table) // функция рисует доску, где start - начальное положение доски
{
	COORD temp = table.start;

	int x = 0; 

	// рисуем саму доску
	for (int i = 0; i <= width; i++)
	{
		for (int i2 = 0; i2 < height; i2++)
		{
			temp.X = table.start.X + i2 * table.size.X;
			draw_square(output, table.text_attr[x], temp, table.size);
			(x == 0) ? x = 1 : x = 0; //Рисует разного цвета клетки
		}
		temp.Y = table.start.Y + i * table.size.Y;
		(x == 0) ? x = 1 : x = 0; // Изменение для следующей строки
	}

	COORD temp1 = {table.start.X + 1, table.start.Y - 1};

	SetConsoleTextAttribute(output, 12 | SCREEN_COLOR);
	for (int z = 1; z <= 10; z++)
	{
		SetConsoleCursorPosition(output, temp1);
		cout << z;
		temp1.X += table.size.X; 
	}

	COORD temp2 = {table.start.X - 1, table.start.Y + 1};
	char russian_letters[] = {"АБВГДЕЖЗИК"};
	char buf[10];
	AnsiToOem(russian_letters, buf);
	
		for (int z1 = 0; z1 < 10; z1++)
		{
			SetConsoleCursorPosition(output, temp2);
		cout << buf[z1];
		temp2.Y += table.size.Y; 
		}
	return true;
}

void ConsoleTitle (const HANDLE output, const char text[])   // написать название консоли
{
	char buf[100];
	AnsiToOem(text, buf);
	SetConsoleTitle(buf);
}

void gotoxy (const HANDLE output, const int x, const int y) // функция устанавливает курсор в заданном месте. Сделана с целью упрощения функции SetConsoleCursorPosition ( не нужно создавать переменную типа COORD);
{
	COORD temp = {{x}, {y}};
	SetConsoleCursorPosition(output, temp);
}

int char_size (char x[]) // функция возращает размер строки как числовое значение
{
	int i = 0;
	while (x[i] != '\0') i++;
	return i;
}

void clear_window (const HANDLE output, coords Win_Coords) // функция очищает содержимое окна по заданным координатам окна
{
	SetConsoleTextAttribute(output, 3 * 16);
	int cur_x = Win_Coords.x1 + 1,
		cur_y = Win_Coords.y1 + 1;

	for (; cur_y < Win_Coords.y2; cur_y++)
	{	
		gotoxy(output, cur_x, cur_y);
		for (int i = cur_x; i < Win_Coords.x2; i++)
		cout << " ";
	}
}

	void write_in_window(const HANDLE output, coords Win_Coords, char text[]) // функция выводит строку текста в окне, причем так, чтобы она не выходила за границы. Если текст выходит за нижнюю границу, то та часть, которая выходит, обрезается.
	{
		int cur_x = Win_Coords.x1 + 1,
			cur_y = Win_Coords.y1 + 1,
			width = Win_Coords.x2 - Win_Coords.x1 - 1;

		char buf[100];
	
		AnsiToOem (text, buf);
		
		SetConsoleTextAttribute(output, 13 | BACKGROUND_BLUE);
		clear_window(output, Win_Coords);
		gotoxy(output, cur_x, cur_y);

		  
		for (int i = 0; buf[i] != '\0'; i++)
		{
			cout << buf[i];
			width--;
			if (width == 0)
			{
				cur_y++;
				gotoxy(output, cur_x, cur_y);
				width = Win_Coords.x2 - Win_Coords.x1 -1;
			}
			if (cur_y == Win_Coords.y2)
				break;
		}
	}
	
void draw_window(const HANDLE output, coords Win_Coords,  char title[]) // функция рисует границы окна по заданным координатам и его заголовок
{
	  SetConsoleTextAttribute(output, 15);
	
	  gotoxy (output, Win_Coords.x1, Win_Coords.y1);
      cout << char(218);      // левый верхний угол
      gotoxy (output, Win_Coords.x2, Win_Coords.y1);
      cout << char(191);         // правый верхний угол
      gotoxy (output, Win_Coords.x1, Win_Coords.y2);    
      cout << char(192);          // левый нижний угол
      gotoxy (output, Win_Coords.x2, Win_Coords.y2);          
	  cout << char(217); // правый нижний угол

	              // горизонтальные границы 
    for (int count1 = Win_Coords.x1 + 1; count1 < Win_Coords.x2; count1++)
    {
          gotoxy (output, count1, Win_Coords.y1);    
		  cout << char(196); 
          gotoxy (output, count1, Win_Coords.y2);   
          cout << char(196);    
    }
				// вертикальные границы
    for (int count2 = Win_Coords.y1 + 1; count2 < Win_Coords.y2; count2++)
    {
          gotoxy (output, Win_Coords.x1, count2);    
		  cout << char(179); 
	      gotoxy (output, Win_Coords.x2, count2);  
          cout << char(179); 
    }
                // рисуем заголовок окна по центру окна
	    char buf[50];
		AnsiToOem(title, buf);
		gotoxy (output, (Win_Coords.x1 + Win_Coords.x2) / 2 - char_size (title) / 2 + 1, Win_Coords.y1);
		cout << buf;

		clear_window(output, Win_Coords);
}
	
	

void ClearScreen (int color, char sym) // заполняет экран символами определенного цвета
{
	LPDWORD realnum = 0; 
	COORD start = {0, 0}; // откуда начинаем заполнять

	FillConsoleOutputCharacter(output, sym, 80*25, start, realnum);   // заполним символами;
	FillConsoleOutputAttribute(output, color, 80*25, start, realnum); // заполним цветом
}


void ship_stars (char *stars[]) // хранит графическое выражение элемента корабля и возращает его как параметр
{
	stars[0] = "***";
	stars[1] = "***";
}

void miss_stars (char *stars[])
{
	stars[0] = " . ";
	stars[1] = "   ";
}

void destroyed_stars (char *stars[])
{
	stars[0] = "xxx";
	stars[1] = "xxx";
}

COORD GetOffset (const HANDLE output, board table, const COORD field_coords)  // с помощью этой функции можно получить начальные координаты любой клетки на доске
{
	COORD return_value; // возвращаемое значение
	
	return_value.X = table.start.X + table.size.X * field_coords.Y;
	return_value.Y = table.start.Y + table.size.Y * field_coords.X; 

	return return_value;
}

int get_color_index (board table, COORD coordinates) // функция возвращает цвет клетки доски по заданным координатам
{
	
	if (coordinates.Y % 2 == 0)
		return (coordinates.X % 2 == 0) ? 1 : 0;
	else
		return (coordinates.X % 2 == 0) ? 0 : 1;
}

void draw_at_square(const HANDLE output, board table, int color, COORD start, void (*image)(char*[])) // функция рисует корабль в указанных координатах доски
{
		
	int	color_index = get_color_index(table, start);  // фон клетки, на которую мы будем рисовать
		color = color | table.text_attr[color_index]; // цвет корабля совмещаем с фоном клетки

	start = GetOffset (output, table, start); // получаем координаты на экране

	SetConsoleTextAttribute(output, color);

	char *stars[2]; // переменная, которая будет хранить изображение корабля

    //ship_stars(stars); // получаем эти изображения
	image(stars);

		    // рисуем его на экране
	for (int i = 0; i < 2; i++)
	{
		SetConsoleCursorPosition(output,  start);
		cout << stars[i];
		start.Y++;
	}
}

void draw_ships (const HANDLE output, ship_field field, board table, ships_type ships, player_type player) // функция рисует все корабли на поле
{
   
	for (int i = 0; i < 10; i++)
	{
		ship_coordinates *ship_p = &ships[i].one_d_ship;
					// рисуем центр корабля
		for (int i2 = 0; i2 < ships[i].sort; i2++)
			draw_at_square(output, table, (player == user) ? user_ships_color : comp_ships_color, ship_p[i2].coords, &ship_stars);
		
	}
}

	
bool InField (COORD coordinates, board table) // функция проверяет, находятся ли координаты в пределах доски
{
	if (coordinates.X >= table.start.X && coordinates.X <= table.start.X + width * table.size.X -1) 
		if (coordinates.Y >= table.start.Y && coordinates.Y <= table.start.Y + height * table.size.Y -1)
			return true;
		
	return false;
}

bool InSquare (COORD coords, COORD size, COORD check_coords) // функция проверяет, находятся ли проверяемые координаты в пределах клетки
{
	int end_coords_X = coords.X + size.X - 1,
	    end_coords_Y = coords.Y + size.Y - 1;
	
	if (check_coords.X >= coords.X && check_coords.X <= end_coords_X)
		if(check_coords.Y >= coords.Y && check_coords.Y <= end_coords_Y)
			return true;
	return false;
}



COORD GetXYbyOffset(COORD coordinates, board table)  // возвращает координаты на доске по координатам на экране
{
	COORD return_value; // возвращаемое значение
	return_value.Y = (coordinates.X - table.start.X) / table.size.X;
	return_value.X = (coordinates.Y - table.start.Y) / table.size.Y;
	return return_value;
}

bool FillSquare(COORD coords, board table, int color, player_type player) // функция заливает клетку определенным цветом
{
	coords = GetOffset(output, table, coords); // получаем координаты на доске (экран)

	LPDWORD realnum = 0;

	if (player == user)
		color = comp_ships_color | color;
	else
		color = user_ships_color | color;

	        // заливаем каждую горизонталь по вертикали
	for (int i = table.size.Y; i != 0; i--)
	{
		FillConsoleOutputAttribute(output, color, table.size.X, coords, realnum); // заливаем горизонталь
		coords.Y++;
	}
	return true;
}
	
	


COORD click_move(board table) // с помощью этой функции делается ход мышкой
{
	INPUT_RECORD buf[1];   // буфер для хранения сообщений консоли
	DWORD num;
    _MOUSE_EVENT_RECORD &MouseEvent = buf[0].Event.MouseEvent; // ссылка на сообщения мыши

	while (true) // пока ход не сделан
	{
		ReadConsoleInput(input, buf, 1, &num); // читаем сообщения консоли

		if (InField(MouseEvent.dwMousePosition, table)) // если мышка в рамках поля
		{

		    COORD square_field = GetXYbyOffset(MouseEvent.dwMousePosition, table); // координаты клетки в поле
			COORD square = GetOffset(output, table, square_field); // получаем начальные координаты клетки на экране
			
			FillSquare(square_field, table, SELECT_COLOR, user); // заполним квадрат, на котором мышка

			while (InSquare(square, table.size, MouseEvent.dwMousePosition)) // пока мышка находится в рамках клетки
			{
				ReadConsoleInput(input, buf, 1, &num); // читаем сообщения консоли

				if (MouseEvent.dwButtonState == 1) // если нажата левая кнопка
				{
					while (MouseEvent.dwButtonState != 0)    // пока лева кнопка не отпущена
						ReadConsoleInput(input, buf, 1, &num); // читаем сообщения консоли

					if (InSquare(square, table.size, MouseEvent.dwMousePosition)) // если курсор мыши находится все на той же клетке
					{
					FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // заполняем клетку родным фоном
					return GetXYbyOffset (MouseEvent.dwMousePosition, table); // возращает координаты для массива
					}
				}
			}

			FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // мышь убрана с клетки, заполняем клетку ее родным фоном

		}
	}
	
}

COORD keyboard_move (board table) // с помощью этой функции делается ход клавиатурой
{
	INPUT_RECORD buf[1];   // буфер для хранения сообщений консоли
	DWORD num;
	char enter_keys[] = {"WwAaSsDd"};
	CHAR &KeyPressed = buf[0].Event.KeyEvent.uChar.AsciiChar;

	COORD square_field = {0, 0}; // координаты клетки в поле
	FillSquare(square_field, table, SELECT_COLOR, user); // заполним квадрат

	do // пока ход не сделан
	{
		ReadConsoleInput(input, buf, 1, &num); // читаем сообщения консоли

		if (check_sym_in_array(KeyPressed, enter_keys))
		{
			
			FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // заполняем клетку родным фоном
			if (buf[0].Event.KeyEvent.bKeyDown)
			if (KeyPressed == 'w' || KeyPressed == 'W')
				move_element(square_field, to_up);
			else
				if (KeyPressed == 's' || KeyPressed == 'S')
					move_element(square_field, to_down);
			else
				if (KeyPressed == 'd' || KeyPressed == 'D')
					move_element(square_field, to_right);
			else
				if (KeyPressed == 'a' || KeyPressed == 'A')
					move_element(square_field, to_left);

			FillSquare(square_field, table, SELECT_COLOR, user); // заполним квадрат
		}
	}while (KeyPressed != char(13));

	while (buf[0].Event.KeyEvent.bKeyDown)
		ReadConsoleInput(input, buf, 1, &num); // читаем сообщения консоли
	return square_field;
}
		





void HideCursor(HANDLE output) // функция убирает курсор с экрана
{
	CONSOLE_CURSOR_INFO cursor = {1, false};
	SetConsoleCursorInfo(output, &cursor); 
}


// функция проверяет не уничтожена ли часть корабля 
bool check_ship_for_destroyed_parts (ship_type &ship, COORD shot_coords)
{
	ship_coordinates *ship_p = &ship.one_d_ship; // указатель на первый элемент любого корабля

	           /* просматриваем все элементы корабля и проверяем - не уничтожена ли какая то его часть */
	for (int i = 0; i < ship.sort; i++)
		if (shot_coords.X  == ship_p[i].coords.X && shot_coords.Y == ship_p[i].coords.Y) // если координаты выстрела совпадают с координатами части корабля
		{
			if (ship_p[i].alive)
			{
				ship_p[i].alive = false; //то часть корабля уничтожена
				return true;
			}
			write_in_window(output, win_message_coords, "Ошибка игры.Часть корабля уже уничтожена Функция check_ship_for_destroyed_parts");
			return false;
		}
	return false;	// если никакой элемент ни одного корабля не уничтожен
}




     /* функция проверяет корабль на полное уничтожение,
      если все его части уничтожены, то функция
		уничтожает весь корабль и возвращает true.
		Если корабль до проверки уже уничтожен, то функция возращает true*/
		
bool check_ship_for_all_destroyed (ship_type &ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;
		/* просматриваем все элементы корабля*/
	for (int i = 0; i < ship.sort; i++)
		if (ship_p[i].alive)  // если хоть один элемент живой
			return false;

	ship.alive = false; // уничтожаем весь корабль, если все его элементы уничтожены
	return true;
}


     /* возращает строку сообщения уничтожения */
char* destroy_message(ship_sort ship, player_type player)
{
	char* return_message;
	if (player == pc)
		return_message = "Ваш корабль уничтожен";
	else
		return_message = "Вы уничтожили корабль компьютера";
	return return_message;
}
	


          /* данная функция проверяет ход игрока на правильность
			если он уже ходил на ту клетку, то функция возращает true,
			  иначе false */
bool check_move_for_correctness(const COORD move_coords, const ship_field enemy_field)
{
	if (enemy_field[move_coords.X][move_coords.Y] == MISS)
	{
		write_in_window(output, win_message_coords, "Вы уже ходили на эту клетку");
		return false;
	}
	if (enemy_field[move_coords.X][move_coords.Y] == DESTROYED)
	{
		write_in_window(output, win_message_coords, "Эта часть корабля уже уничтожена. Сюда ходить нельзя.");
		return false;
	}
	return true;
}    


    /* функция выводит отдельный корабль на граф. доску*/
void write_ship_at_field(ship_type ship, board table, int color)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		draw_at_square(output, table, color, ship_p[i].coords, ship_stars);
}




     /* проверяет ход и совершает логические действия */
ship_type* check_move(COORD move_coords, ship_field field, ships_type &enemy_ships, player_type player)
{
	if (field[move_coords.X][move_coords.Y] == SHIP_PART) // если мы попали на часть корабля
	{
		/* ищем в массиве кораблей эту часть*/
		for (int i = 0; i < 10; i++)
			if (check_ship_for_destroyed_parts(enemy_ships[i], move_coords)) // если уничтожена часть корабля
			{
					if (check_ship_for_all_destroyed (enemy_ships[i])) // если уничтожен весь корабль
					{
						write_in_window(output, win_message_coords, destroy_message(enemy_ships[i].sort, player));
						set_area_near_ship_destroyed(field, enemy_ships[i]); // очищаем площадь возле подбитого корабля
					}
					break;
			}

			field[move_coords.X][move_coords.Y] = DESTROYED;   // уничтожаем корабль на поле
						
			return &enemy_ships[i]; // возвращает ссылку на вражеский подбитый корабль
			
	}
	else
		if (field[move_coords.X][move_coords.Y] != DESTROYED)
		{
			  field[move_coords.X][move_coords.Y] = MISS; // мимо
			  return 0;
		}
}


              /* функция выводит результат на экране*/
void write_result_in_table(COORD move_coords, ship_field field, board table, player_type player)
{
	

	
	
	if (field[move_coords.X][move_coords.Y] == MISS)
		draw_at_square(output, table, (player == user) ? comp_shot_color : comp_ships_color, move_coords, &miss_stars);
	else
		if (field [move_coords.X][move_coords.Y] == DESTROYED)
				draw_at_square(output, table, (player == user) ? comp_shot_color : comp_ships_color, move_coords, &destroyed_stars);

}


            
		/* функция делает ход игрока*/
bool do_user_move (ship_field enemy_field, ships_type &enemy_ships, board &enemy_table)
{

	bool return_value; // возращаемое значения
	bool game_ok;
	
	do{

		COORD move_coords ={0}; // координаты хода
		move_coords = keyboard_move(enemy_table); // координаты хода
		game_ok = check_move_for_correctness(move_coords, enemy_field);
		return_value = (check_move(move_coords, enemy_field, enemy_ships, user) != 0); 
		write_result_in_table(move_coords, enemy_field, enemy_table, pc);
	}while (!game_ok);

	return return_value;
	
}



       /*функция проверяет все возможные "правильные" ходы на определенном поле и закидывает их в массив moves*/
bool check_all_moves (ship_field field, moves_type moves, int &num_of_moves)
{
	num_of_moves = 0; // кол-во найденных ходов
	
	for (int i = 0; i < width; i++)
		for (int i2 = 0; i2 < height; i2++)
			    /* если клетка не равна "мимо" или "уничтоженному кораблю" или "площади возле уничтоженного корабля */
			if (field[i][i2] != MISS && field[i][i2] != DESTROYED && field[i][i2] != AREA_NEAR_DESTROYED)
			{
				moves[num_of_moves].X = i;
				moves[num_of_moves].Y = i2;
				num_of_moves++;
			}

	return (num_of_moves > 0); // если кол-во ходов больше нуля, то вернем true
}


    /* алгоритм тупого компьютера, который выбирает ход случайно
	      и возвращает его в move_coords */
bool stupid_comp_algorithm (ship_field enemy_field, COORD &move_coords)
{
	moves_type all_moves; // все возможные ходы
	COORD comps_move = {0}; // выбранный ход
	int num_of_moves; // кол-во ходов

	check_all_moves(enemy_field, all_moves, num_of_moves); // находим все возможные ходы

	move_coords = all_moves[rand() % num_of_moves]; // случайным образом получаем ход

	return true;
}


               /* функция для функции алгоритма умного компьютера
			      осуществляет ход компьютера, если список удачных ходов пуст*/
COORD clever_no_lucky_moves(ship_field enemy_field, ships_type &enemy_ships, lucky_moves_struct &lucky_moves)
{
	COORD move_coords; // ход компьютера
	stupid_comp_algorithm(enemy_field, move_coords); // случайно выбираем ход
	ship_type *destr_ship = check_move(move_coords, enemy_field, enemy_ships, pc); // проверяем ход	и возращаем указатель на сбитый корабль
    	if ( destr_ship != NULL)// если ход не "мимо" и не уничтожен однопалубный корабль	
			if (destr_ship->sort != one_decker)
				lucky_moves.arr[lucky_moves.num_of_moves++] = move_coords; // добавляем в массив удачных
	return move_coords;
}

/* функция для функция алгоритма умного компьютера
			      осуществляет дествия, если есть один  удачный ход*/

void clever_one_lucky_move(const COORD element, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves)
{
	for (int i = to_right; i <= to_up; i++)
	{
		COORD temp = element; // будем ходить с этого элемента
		move_element(temp, (move_side)i); // проверим сторону
		if (check_value_in_square(temp)) // если в пределах поля
			if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // и на эти клетки логично ходить
				all_clever_moves[num_of_moves++] = temp;
	}
	if (num_of_moves == 0)
		write_in_window(output, win_message_coords, "Ошибка в функции clever_one_lucky_move. Не найден ни один умный ход");

}


void sort_lucky_moves_by_X(lucky_moves_struct &lucky_moves)
{
	for (int i = 0; i < lucky_moves.num_of_moves; i++)
		for (int i2 = i + 1; i2 < lucky_moves.num_of_moves; i2++)
			if (lucky_moves.arr[i2].X < lucky_moves.arr[i].X)
				swap_two_integers(lucky_moves.arr[i2].X, lucky_moves.arr[i].X);
}

		
			/* сортируем удачные ходы по Y */
void sort_lucky_moves_by_Y(lucky_moves_struct &lucky_moves)
{
	for (int i = 0; i < lucky_moves.num_of_moves; i++)
		for (int i2 = i + 1; i2 < lucky_moves.num_of_moves; i2++)
			if (lucky_moves.arr[i2].Y < lucky_moves.arr[i].Y)
				swap_two_integers(lucky_moves.arr[i2].Y, lucky_moves.arr[i].Y);
}

void clear_lucky_moves(lucky_moves_struct &lucky_moves)
{
	for (int i = 0; i < 4; i++)
	{
		lucky_moves.arr[i].X = 0;
		lucky_moves.arr[i].Y = 0;
	}
	lucky_moves.num_of_moves = 0;
}
	
/* функция для функция алгоритма умного компьютера
			      осуществляет дествия, если есть два и более удачных хода*/
void clever_two_more_moves (lucky_moves_struct &lucky_moves, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves)
{
	turning_side_type enemy_ship_position; // положение корабля врага (горизонтальное, вертикальное);

	enemy_ship_position = get_turning_side_by_coords(lucky_moves.arr[0], lucky_moves.arr[1]); // получаем это положение

		
	if (enemy_ship_position == horizontal) // если положение корабля горизонтальное
	{
		sort_lucky_moves_by_Y(lucky_moves);     // сортируем по X;

		/* проверим две стороны */
		for (int i = 0; i != 4; i+=2)
		{
			COORD temp = (i == 0) ? lucky_moves.arr[lucky_moves.num_of_moves-1] : lucky_moves.arr[0];;
			move_element(temp, (move_side)i); // проверим сторону
			if (check_value_in_square(temp)) // если в пределах поля
				if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // и на эти клетки логично ходить
					all_clever_moves[num_of_moves++] = temp;
		}
		if (num_of_moves == 0)
			write_in_window(output, win_message_coords, "Ошибка игры. Не найдено ни одного умного хода. Горизонтальное. Clever_two_more_moves.");

	}
		else // иначе, если положение корабля вертикальное
		{
			sort_lucky_moves_by_X(lucky_moves);     // сортируем по Y;
					/* проверим две стороны */
			for (int i = 1; i != 5; i+=2)
			{
				COORD temp = (i == 1) ? lucky_moves.arr[lucky_moves.num_of_moves-1] : lucky_moves.arr[0];;
				move_element(temp, (move_side)i); // проверим сторону
				if (check_value_in_square(temp)) // если в пределах поля
					if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // и на эти клетки логично ходить
						all_clever_moves[num_of_moves++] = temp;
			}
				if (num_of_moves == 0)
			write_in_window(output, win_message_coords, "Ошибка игры. Не найдено ни одного умного хода. Вертикальное. Clever_two_more_moves.");

		}
}




                  /*алгоритм умного компьютера*/
bool clever_comp_algorithm(ship_field enemy_field, ships_type &enemy_ships, COORD &move_coords)
{
	static lucky_moves_struct lucky_moves = {0}; // структура удачных ходов
	ship_type* destr_ship;  // указатель на уничтоженный корабль

	if (lucky_moves.num_of_moves == 0) // если удачных ходов нет, то
	{
		move_coords = clever_no_lucky_moves(enemy_field, enemy_ships, lucky_moves); // вызываем функцию для обработки этого условия
		return (lucky_moves.num_of_moves > 0); // если есть удачный ход (попадание), то вернем true
	}

	else // если удачных ходов больше одного
	{
		COORD all_clever_moves[4]; // массив, который будет содержать число всех умных ходов
		int num_of_moves = 0; // кол-во умных ходов
		
		
		if (lucky_moves.num_of_moves == 1) // если один удачный ход, то
			clever_one_lucky_move(lucky_moves.arr[0], enemy_field, all_clever_moves, num_of_moves); 

		else // если удачных ходов больше 1, то
			clever_two_more_moves(lucky_moves, enemy_field, all_clever_moves, num_of_moves);
			
		move_coords = all_clever_moves[rand() % num_of_moves]; // случайно выберем ход из массива "умных ходов"

		destr_ship = check_move(move_coords, enemy_field, enemy_ships, pc); // проверяем ход

			if (destr_ship != 0)  // если попали
			{
				lucky_moves.arr[lucky_moves.num_of_moves++] = move_coords; // добавляем в массив удачных ходов
				if (destr_ship->alive == false) // если весь корабль уничтожен
						clear_lucky_moves(lucky_moves); // очищаем массив удачных ходов
			}

	}
	return (destr_ship != 0);
}


bool do_comp_move(ship_field enemy_field, ships_type &enemy_ships, board &enemy_table)
{
	COORD move_coords; // выбранный компьтером ход
	move_result_type move_result; // результат хода
//	bool return_value = false;

	/*stupid_comp_algorithm(enemy_field, move_coords);
	check_move(move_coords, enemy_field, enemy_ships, pc); */
    bool return_value = clever_comp_algorithm(enemy_field, enemy_ships, move_coords); 
	write_result_in_table(move_coords, enemy_field, enemy_table, user); 

	return return_value;
}


    /* функция проверяет массив с кораблями на проигрыш.
		Возвращает true, если все корабли уничтожены*/
bool check_ships_for_loose (const ships_type ships)
{
	for (int i = 0; i < 10; i++)
		if (ships[i].alive)
			return false;
	return true;
}


  
game_status check_game_status(ships_type user_ships, ships_type comp_ships) // функция проверяет и возвращает состояние игры
{
	if (check_ships_for_loose(comp_ships)) // если все корабли компьютера уничтожена
		return user_win;                 // пользователь выиграл
	else
		if (check_ships_for_loose(user_ships)) // если все корабли пользователя уничтожены
			return pc_win;                    // компьютер выиграл
		else
			return game;                      // продолжать игру
}

bool reload()  // функция, которая предлагает сыграть еще раз и возращает true, если пользователь согласился на это
{
    	write_in_window(output, win_message_coords, "Вы хотите сыграть снова? Y/N");
		INPUT_RECORD buf[1];
		DWORD num;
		char &key = buf[0].Event.KeyEvent.uChar.AsciiChar;
		do{
		ReadConsoleInput(input, buf, 1, &num);
		}while (key != 'y' && key != 'Y' && key != 'n' && key != 'N');
		if (key == 'y' || key == 'Y')
			return true;
		else
			return false;
}

bool write_in_window_line (coords win_coords, int line, char text[])
{
	int line_correct = (win_coords.y2 - win_coords.y1 - 2);
	if (line > line_correct || line == 0)
		return false;
	gotoxy(output, win_coords.x1+1, win_coords.y1 + line);

	char buf[200];
	AnsiToOem(text, buf);

	int temp = win_coords.x1+1;

	for (int i = 0; buf[i] != '\0'; i++)
	{
		cout << buf[i];
		temp++;
		if (temp == win_coords.x2)
		{
			line++;
			temp = win_coords.x1+1;
			gotoxy(output, temp, win_coords.y1 + line);
			
		}
			
	}
	return true;
}




       /* Функция выводит окно приветсвия, где win_coords - координаты окна*/
void hello_window(const coords win_coords)
{
	
	
	draw_window(output, win_coords , "Морской бой");
	clear_window(output, win_coords);
	write_in_window_line(win_coords, 1, "Добро пожаловать в Морской бой!");
	write_in_window_line (win_coords, 3, "Эта игра разрабатывалась на С++. Скомпилирована в Visual C++ 6.");
	write_in_window_line (win_coords, 6, "Игра осуществляется с помощью мыши. Для того, чтобы сделать ход, необходимо щелкнуть левой кнопкой мыши по клетке.");
	write_in_window_line (win_coords, 10, "*** - живой корабль");
	write_in_window_line (win_coords, 11, ". - означает то, что выстрел был сделан мимо");
	write_in_window_line (win_coords, 12, "xxx - означает то, что было попадание в часть корабля");
	write_in_window_line (win_coords, 15, "Нажмите -Enter- для того, чтобы продолжить");
}

   /* функция управляет окном приветствия, где win_coords - координаты окна*/
void hello_window_driver(coords win_coords)
{
	CHAR_INFO buf[2000];
	SMALL_RECT rect = {10, 3, 60, 20};
	COORD buf_coord = {0, 0};
	COORD buf_size = {80, 25};
	
	ReadConsoleOutput(output, buf, buf_size, buf_coord, &rect);
	hello_window(win_coords);

	INPUT_RECORD input_buf[1];
	DWORD num;
	char &key = input_buf[0].Event.KeyEvent.uChar.AsciiChar;
		
	do{
		ReadConsoleInput(input, input_buf, 1, &num);
	}while (key != char(13)); 

	while (input_buf[0].Event.KeyEvent.bKeyDown)    // пока кнопка не отпущена, продолжать чтение 
			ReadConsoleInput(input, input_buf, 1, &num);

	WriteConsoleOutput(output, buf, buf_size, buf_coord, &rect);
	
	
}


	/* функция сравнивает координаты coords с координатами корабля
	   возвращает true, если часть корабля находится в этих координатах,
		 иначе false*/
bool get_ship_by_xy(const COORD coords, ship_type ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		if (ship_p[i].coords.X == coords.X && ship_p[i].coords.Y == coords.Y)
			return true;
	return false;
}


       /* функция возвращает указатель на корабль по координатам
			если часть какого то корабля лежит в этих координатах,
			  то возвращается указатель на него, иначе возращается 0*/
int get_ships_by_xy(const COORD coords, ships_type ships)
{
	for (int i = 0; i <10; i++)
		if (get_ship_by_xy(coords, ships[i]))
			return i;
	return -1;
}



void delete_ship (const HANDLE output, board table, COORD start) // функция удаляет корабль по указанным координатам
{
	
		int color_index = get_color_index(table, start);	
		start = GetOffset (output, table, start);
		draw_square(output, table.text_attr[color_index], start, table.size);
}

void draw_field_by_ship(ship_type ship, board table, ship_field field)
{
	
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		if (field[ship_p[i].coords.X][ship_p[i].coords.Y] == SHIP_PART)
			draw_at_square(output, table, user_ships_color, ship_p[i].coords, ship_stars);
		else
			delete_ship(output, table, ship_p[i].coords);
}

				/*функция возращает сторону движения по начальным и конечным координатам (как массив*/

move_side get_move_side_by_coords (char enter_key)
{
	if (enter_key == 'w' || enter_key == 'W')
		return to_up;
	else
		if (enter_key == 's' || enter_key == 'S')
			return to_down;
		else
			if (enter_key == 'a' || enter_key == 'A')
				return to_left;
			else 
				if (enter_key == 'd' || enter_key == 'D')
					return to_right;
				else
					write_in_window(output, win_message_coords, "Ошибка игры. Функция get_move_side_by_mouse()");

}


              /* функция сравнивает две структуры типа first и second,
				возвращает true, если они равны, иначе false*/
bool compare_two_COORD(const COORD first, const COORD second)
{
	return (first.X == second.X && first.Y == second.Y);
}



      /* функция проверяет, пусто ли место, куда мы хотим поставить корабль*/
bool check_field_for_empty(ship_field field, ship_type ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
	{
		if (!check_value_in_square(ship_p[i].coords))
			return false;
		if (field[ship_p[i].coords.X][ship_p[i].coords.Y] != EMPTY)
			return false;
	}
	return true;
}

		/* функция проверяет, находится ли символ в массиве символов.
			Если символ есть в массиве, то вернуть true, иначе false*/
bool check_sym_in_array (char sym, char arr[])
{
	for (int i = 0; arr[i] != '\0'; i++)
		if (sym == arr[i])
			return true;
	return false;
}



void user_ship_replace(ship_field field, ships_type ships, board table)
{
	INPUT_RECORD input_buf[1];
	DWORD num;

	
	COORD &MouseCoords = input_buf[0].Event.MouseEvent.dwMousePosition; // координаты мыши
	DWORD &MouseButton = input_buf[0].Event.MouseEvent.dwButtonState;  // состояние кнопки мыши
	CHAR &KeyPressed = input_buf[0].Event.KeyEvent.uChar.AsciiChar;    // символ нажатой клавиши

	write_in_window(output, win_message_coords, "Расставьте Ваши корабли. Нажмите Esc, чтобы начать игру.");
	

	do{
		
			int cur_index = 0; // текущий корабль массиве (для выбора шашки)
			int selected_color = 15; // цвет выделения шашки
			write_ship_at_field(ships[cur_index], table, selected_color); // нарисуем эту шашку цветом выделения

			do{
				ReadConsoleInput(input, input_buf, 1, &num);  // читаем сообщения с консоли
				if (input_buf[0].EventType == KEY_EVENT) // если событие клавиатуры
				{
					if (input_buf[0].Event.KeyEvent.bKeyDown)    // если нажата кнопка, то
					{
						if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_DOWN   // если нажата "стрелка вниз"
							|| input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_UP) // или "стрелка вверх"
						{
							write_ship_at_field(ships[cur_index], table, user_ships_color); // зарисовываем поле по координатам корабля
							if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_DOWN) // если нажата кнопка "стрелка вниз"
								(cur_index == 0) ? cur_index = 9 : cur_index--;
								else           // если нажата кнопка "стрелка вверх"
									(cur_index == 9) ? cur_index = 0 : cur_index++;

							write_ship_at_field(ships[cur_index], table, selected_color);  // нарисуем шашку цветом выделения
						}
					}


					if (KeyPressed == char(13))   // если нажата кнопка "Enter"
						while (input_buf[0].Event.KeyEvent.bKeyDown)    // пока кнопка не отпущена, продолжать чтение 
													ReadConsoleInput(input, input_buf, 1, &num);
					if (KeyPressed == char(27))  // если нажата кнопка "Esc"
						write_ship_at_field(ships[cur_index], table, user_ships_color); // зарисовать шашку родным цветом


				}
					if (input_buf[0].EventType == MOUSE_EVENT) // если событие мыши
					{
						if (InField(MouseCoords, table)) // если мышка в пределах поля
							if (MouseButton == 1) // если нажата левая кнопка мыши
							{
								COORD field_coords = GetXYbyOffset(MouseCoords, table); // получим клетки
								if (field[field_coords.X][field_coords.Y] == SHIP_PART) // если это часть корабля, то
								{
									write_ship_at_field(ships[cur_index], table, user_ships_color); // зарисовываем поле по координатам корабля
									cur_index = get_ships_by_xy(field_coords, ships);
									break;
								}
							}
					}
			}while (KeyPressed != char(13) && KeyPressed != char(27));
			
		
			if (KeyPressed != char(27))
			{
					
						ship_type *our_ship = &ships[cur_index];
						write_ship_at_field(*our_ship, table, 13); // вывести корабль новым цветом
						get_ship_from_field(field, &our_ship->one_d_ship, our_ship->sort);

						ship_type ship_static = *our_ship;   // сохраняем постоянное положение корабля
						ship_type ship_dynamic = *our_ship;  // сохраняем изменяющееся положение корабля

					//	COORD start_coords = MouseCoords;
						while (true)
						{
							ReadConsoleInput(input, input_buf, 1, &num);

							if (input_buf[0].Event.KeyEvent.bKeyDown)
							{

							char enter_keys[] = {"WwAaSsDd"};
							
								if (check_sym_in_array(KeyPressed, enter_keys)) // если старые и новые координаты клеток не равны
								{
									move_side my_move_side = get_move_side_by_coords (KeyPressed); // находим сторону движения в зависимости от координат мыши
									draw_field_by_ship(ship_dynamic, table, field); // зарисовываем поле по координатам корабля
									move_ship(ship_dynamic, my_move_side);              // двигаем корабль
									write_ship_at_field(ship_dynamic, table, 13);   // рисуем корабль на новом месте
								
								
								}	

									if (KeyPressed == char(13))
									{
										if (check_field_for_empty(field, ship_dynamic))
										{
											add_ship_to_field(field, ship_dynamic);
											*our_ship = ship_dynamic;
											write_ship_at_field(ship_dynamic, table, user_ships_color);
											while (input_buf[0].Event.KeyEvent.bKeyDown)    // пока кнопка не отпущена, продолжать чтение 
													ReadConsoleInput(input, input_buf, 1, &num);
										break;
										}
									}
									if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_BACK)
									{
										draw_field_by_ship(ship_dynamic, table, field); // зарисовываем поле по координатам корабля
										add_ship_to_field(field, ship_static);
										write_ship_at_field(ship_static, table, user_ships_color);
										break;
									} 

									if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_SHIFT)
									{
										draw_field_by_ship(ship_dynamic, table, field); // зарисовываем поле по координатам корабля
										turn_ship(ship_dynamic, ship_dynamic.sort, (turning_side_type)abs_num(ship_dynamic.ship_side - 1));
										write_ship_at_field(ship_dynamic, table, 13);   // рисуем корабль на новом месте
									}
							}

								
						}
			}
							
	}while (KeyPressed != char(27)); 
	clear_window(output, win_message_coords);
}





void main()
{

bool game_continue = false; // переменная, которая отвечает за то, продолжать ли игру. Нужна для того, чтобы реализовать возможность сыграть еще раз. Имеет true, если игру надо продолжать.
bool hello = true; // переменная, которая отвечает за то - отображать ли окно приветсвия
	srand(time(0)); // инициализуем генератор случайных чисел по текущему времени.

	board user_table = {3, 2, 5, 2, 7 * 16, 8 * 16};    // графическое поле игрока
	board comp_table = {3, 2, 40, 2, 6 * 16, 7 * 16};   // графическое поле компьютера
	HideCursor(output);								    // уберем курсор с экрана
	ClearScreen (SCREEN_COLOR, ':');                     // зальем экран определенным цветом
	ConsoleTitle(output, "Морской бой. Автор: kornet."); // создадим заголовок для консоли
	draw_window(output, win_message_coords, "Окно сообщений"); // нарисуем окно сообщений

	DWORD fdwMode = ENABLE_MOUSE_INPUT; 
	SetConsoleMode(input, fdwMode); //Дает возможность ввода с мышки

	
do
{
	game_status status = game; // статус игры - продолжать игру.
	player_type current_player = set_current_player(); // установим текущего игрока
	ship_field user_field = {0}; // поле пользователя
	ship_field comp_field = {0}; // поле компа
	ships_type user_ships, // корабли пользователя
		       comp_ships; // корабли компа

	Init_ships_type (user_ships); // инициализация кораблей пользователя
	Init_ships_type (comp_ships); // инициализация кораблей компьютера
	
	ship_placing(user_field, user_ships); // случайная расстановка кораблей пользователя
	ship_placing(comp_field, comp_ships); // случайная расстановка кораблей компа

	draw_table(output, user_table);  // нарисовать графическое поле пользователя
	draw_table (output, comp_table);	// нарисовать графическое поле компьютера
	if (hello) // если нужно выводить окно приветствия, то
	{
		hello_window_driver(hello_window_coords);
		hello = false;
	}
	draw_ships(output, user_field, user_table, user_ships, user); // нарисовать корабли пользователя
	user_ship_replace(user_field, user_ships, user_table);  // возможность пользователю переставить корабли


	do{
		if (current_player == user)   // если текущий игрок - пользователь
		  while (do_user_move(comp_field, comp_ships, comp_table)); // он делает ход, пока сбивает части кораблей врага
		else                            // иначе текущий игрок - компьютера
			while (do_comp_move(user_field, user_ships, user_table));  // он делает ход, пока сбивает части кораблей врага
		current_player = (player_type)abs_num(current_player-1);  // меняем текущего игрока
	    status = check_game_status(user_ships, comp_ships); // проверим состояние игры
	}while (status == game); // продолжать пока никто не выиграл
  
 game_continue = reload(); // спрашиваем с помощью функции reload() - нужно ли продолжать игру?
}while (game_continue); // продолжать , пока пользователь соглашается продолжать игру


}