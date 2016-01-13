#include <iostream>
#include <windows.h>
#include <ctime>
#include <string>

using namespace std;

const int height = 10; // ����� �������� ���� (� �������)
const int width = 10; // ������ �������� ���� (� �������)

typedef struct {
	COORD size,   // ������ ������
		  start;  // ���������� ������ ������ �� ����� ����� (����� ������� �����)
	int text_attr[2]; // �������� ����� ������
} board; // ��������� ����� �������� ���

typedef int ship_field[height][width]; // ��� - ���� ��� �������� ���
enum ship_sort {one_decker = 1, two_decker, three_decker, four_decker}; // ��� ������� - (������������, ������������, ������������, ������� ��������)

 
             /* ���������, ������� �������� �� ��������� ������� ������� ��� ������ �������, ���� ��� ������������*/
typedef struct
{
	 COORD coords; // ���� ���� ��������� ��� �������� ��������� ������� ������� ��� ������ �������, ���� ��� ������������
	 bool alive; // ����������, ������� �������� �� ��: ���� �� ������ ������ �������. ����� true, ���� ������ ����.
} ship_coordinates;

enum turning_side_type {horizontal = 0, vertical}; // ������������ ���, ������� �������� �� ������������ ������� (��������������, ������������)

            
                                   /* ���������, ������� ������ ��������� � ���������� ������� ������ ���� */
typedef struct
{
	ship_sort sort; // ��� �������
	bool alive; // ����������, ������� �������� �� ��, ��� �� ������ �������. ����� true, ���� �� ���.
	turning_side_type ship_side; // ����������, ������� �������� �� ������������ ������� (��������������, ������������)
	union
	{
		ship_coordinates one_d_ship;        // ������������ �������
		ship_coordinates two_d_ship[2];     // ������������ �������
		ship_coordinates three_d_ship[3];   // ������������ �������
		ship_coordinates four_d_ship[4];    // ��������������� �������
	}; 
} ship_type;

typedef ship_type ships_type[10]; // ��� ������� ����������� ������

typedef struct { int x1, y1, x2, y2;} coords; // ���������� ������������� ������

typedef COORD moves_type[100]; // ������ ������ ���� ����� ������� ��� ��������� ����

typedef struct 
{ 
	COORD arr[3];   // ������ ������� �����, �� �� ����� ���� ����� ����
	int num_of_moves; // ���-�� ������� �����
}   lucky_moves_struct; // ��������� ������� �����


enum game_status {game, pc_win, user_win}; // ������������ ���, ������� �������� �� ��������� ������� ���� (���������� ����, ���� �������, ������������ �������)
enum player_type {user = 0, pc}; // ������������ ���, ������� �������� �� ��, ��� ��� �������  (������������ ��� ����������)

enum move_result_type {miss_shot, destroyed_shot}; // ��������� ���� -(����, ���������)

const HANDLE output = GetStdHandle(STD_OUTPUT_HANDLE); // ���������� ������
const HANDLE input = GetStdHandle(STD_INPUT_HANDLE);   // ���������� �����

const int EMPTY = 0; // ������ ������
const int SHIP_PART = 1; // ������, �� ������� ��������� ����� ������� ��� ���� �������
const int AREA_NEAR_SHIP = 2; // ������ ����� �������, �� ������� ������ ������� ������ �������
const int MISS = 3; // ������ � ������� ��� ������ ������� � �� ������� ������ ���
const int DESTROYED = 4; // ������, � ������� ��� ������ ������� � �� ������� ���� ���������� ����� �������
const int AREA_NEAR_DESTROYED = 5; // ������ ����� ������������� �������

const coords win_message_coords = {5, 22, 69, 24}; // ���������� ���� ���������
const coords hello_window_coords = {10, 3, 60, 20}; // ���������� ���� �����������

const SCREEN_COLOR = 2 * 16; // ���� ���� ����
const SELECT_COLOR = 4 * 16; // ���� ���������� ������

const user_ships_color = 14;
const comp_ships_color = 11;

const comp_shot_color = 9;



enum move_side {to_right = 0, to_down, to_left, to_up}; // ������������ ���, ������� �������� �� �������, � ������� �� ������� �������

/* ................................��������� �������..................................*/


/*.................................�������, ���������� �� ������ ����................................*/


/*add_coords_to_ship_coordinates(...)
  ������� ����������� ���������� �� ������� element ����������� �������,
  ship - �������, ����������� �������� ����� ��������� ������
  *element - ��������� �� ��������� ���� COORD, ������� �������� ����������
  */
void add_coords_to_ship_coordinates(ship_type &ship, COORD *element); 

 /* add_ship_element_to_field(...)
	������� ��������� ��������� ������� ������� �� ����,
	   ��� ���� ��� ��������� ������� ����� �������.
	   ������, �� ������� �������� ������� �� ����������� �� ��������, �
	   ������ �� �������������� ����.
		    field - ���� ��� �������� ���
		   coordinates - ���������� �������� �������
	   ���������� true, ���� ������� ��� ������� ���������.
	     false, ���� ������ �� ��������� ����.*/
bool add_ship_element_to_field (ship_field field, COORD ship_coordinates);

 /* add_ship_to_field (...)
		������� ������ ������� �� ����.
		field - ����, �� ������� ����� ���������.
		ship - �������, ������� ����� ���������
			*/

bool add_ship_to_field (ship_field field, ship_type& ship);

/*	add_to_coords (...)
	������� ��������� � element - added, ���
      element - ��������� �� ������ ������� ������� COORD 
	  added - ��������� �� ������ ������� ������� COORD 
	  int x - ���-�� ��������� � �����  ��������.
	  ���� x <= 0, �� ������� ��������� false, ����� true
	  */
bool add_to_coords (COORD* element, const COORD *added, int x);

/* add_value_to_field(...)
	������ ������� ��������� �������� �� ������������ ������ ���� ��� �������� ���.
     field - ����
	 value - �������� ������� ���� ��������,
	 coordinates - ���������� ����, �� ������� ���� �������� ��������.
	 ������ �������, ���������� true, ���� coordinates ��������� �� ���������� � �������� ����
	 � �������� ������� ���� ���������. ���� coordinates �� ��������� ����, �� false*/
bool add_value_to_field (ship_field field, const int value, const COORD coordinates);

       /*check_all_moves()
	    ������� ��������� ��� ��������� "����������" ���� �� ������������ ���� � ���������� �� � ������ moves.
			field - ����, �� ������� ������������ ����.
			moves - ������ � ������
			num_of_moves - ���������� �����.
			������ ������� ������������ �����������.
			"������������" ���� �������� ��, �� ������� �� �������������. �������� ������������ ������ �� ������
				����� �� ������ ��������.*/
bool check_all_moves (ship_field field, moves_type moves, int &num_of_moves);

      /* ������� ���������, ����� �� �����, ���� �� ����� ��������� �������.
			���������� true, ���� ����� ����� � �� ��� ����� ����� ��������� �������, ����� false.
			field - ���� ��� �������� ���
			ship - �������, ������� �� ����� ���������*/
bool check_field_for_empty(ship_field field, ship_type ship);

/* bool check_if_not_value_in_field(...)
			������ ������� ���������, ��� �� ������ �������� � ������������ ����� ����.
		 field - ����, ������� ����� ���������
		 value - ����������� ��������
		 coordinates - ���������� ����
         ���������� true, ���� ������ �������� ���.
		 ���������� false 1) ���� ���� ����� ��������
		                  2) ���� ���������� - �� ��������� ����
						  */
       
bool check_if_not_value_in_field (ship_field field, const int value, const COORD coordinates);

/* ship_type* check_move(...);
	������� ��������� ���, ��������� ������������� � ��������� ������������ ���������� ��������.
	���������� ��������� �� �������� �������; ���� ������� ��� ������ ����, �� ���������� 0.
	move_coords - ���������� ����
	field - ���� ��� �������� ���, ��� ��� ������ ���
	enemy_ships - ������ �������� �����
	player - �����, ��� �������� ��������� �������� ����.
	*/
ship_type* check_move(COORD move_coords, ship_field field, ships_type &enemy_ships, player_type player);

       /* bool check_move_for_correctness(...)
			������ ������� ��������� ��� ������ �� ������������
			���� �� ��� ����� �� �� ������, �� ������� ��������� true,
			  ����� false.
			  move_coords - ���������� ����
			  enemy_field - ���� ��� �������� ���, ��� ��� ������ ���*/
bool check_move_for_correctness(const COORD move_coords, const ship_field enemy_field);

 /* bool check_ship_for_all_destroyed(...)
	������� ��������� ������� �� ������ �����������,
      ���� ��� ��� ����� ����������, �� �������
		���������� ���� ������� � ���������� true.
			ship - ����������� �������*/
bool check_ship_for_all_destroyed (ship_type &ship);

/* bool check_ship_for_destroyed_parts(...)
		������� ��������� �� ��������� �� ����� �� ������� �������,
	         � �������� ��������� ������� (ship), ���� ������� ���������
	        ship - ����������� �������
			shot_coords - ���������� ����
		������� ���������� true, ���� ��������� ������� �������, ����� false;
		*/
bool check_ship_for_destroyed_parts (ship_type &ship, COORD shot_coords);

	/* bool check_ship_in_field(
		������� ���������, ��������� �� ������� � ������ ����.
		���� ������� � ������ ����, �� ������� ��������� true, ����� false;
		ship - ����������� ������� */
bool check_ship_in_field(ship_type ship);

 /* check_ship_in_square
	������� ���������, ��������� �� ������� � �������� ����, COORD - ��������� �� ������ ������� �������,
          ship - ��� �������, 
 ���������� true, ���� ������� � �������� ����, ����� false.
	�� ���������� ���������� ������� check*/

bool check_ship_in_square (COORD *element, ship_sort ship);

  /* ������� ��������� ������ � ��������� �� ��������.
		���������� true, ���� ��� ������� ����������.
			ships - ������ � ���������*/
bool check_ships_for_loose (const ships_type ships);


 /* check_value_in_square (...)
   ������� ���������, ��������� �� ������� � ������ ������������ � �������� ����.
	���������� true, ���� ������� ��������� � �������� ����, ����� false;
	element - ������� 
	*/

bool check_value_in_square (const COORD element);

                  /* bool clever_comp_algorithm(...)
					�������� ������ ����������. �������, � ������� ������� ������������ ��� ����������.
					���� ��� ��� �������(������ � �������), �� ������������ true, ����� ������������ false.
					enemy_field - ���� ��� �������� ��� �� ������� �����
					enemy_ships - ������� ����� (� ����� ������, ������������)
					move_coords - ���������� ����*/
bool clever_comp_algorithm(ship_field enemy_field, ships_type &enemy_ships, COORD &move_coords);

/* COORD clever_no_lucky_moves(...)
	������� ��� ������� ��������� ������ ���������� clever_comp_algorithm(...)
         ������������ ��������, ���� ������ ������� ����� ����.
		 enemy_field - ����, �� ������� �����
		 enemy_ships - ������� �����
		 lucky_moves - ��������� ������� �����.
			���������� ��� ����������*/
COORD clever_no_lucky_moves(ship_field enemy_field, ships_type &enemy_ships, lucky_moves_struct &lucky_moves);

/* clever_one_lucky_move(...)
			������� ��� ������� ��������� ������ ����������
			      ������������ �������, ���� ���� ����  ������� ���.
				element - ������� ���
				enemy_field - ���� �� �������� ���, �� ������� �����
				all_clever_moves[] - ������ "�����" �����
				num_of_moves - ����������*/

void clever_one_lucky_move(const COORD element, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves);

/*		clever_two_more_moves(...)
			������� ��� ������� ��������� ������ ����������.
			      ������������ �������, ���� ���� ��� � ����� ������� ����.
				lucky_moves - ��������� ������� �����
				enemy_field - ���� �� �������� ���, �� ������� �����
				all_clever_moves[] - ������ "�����" �����
				num_of_moves - ����������	*/
void clever_two_more_moves (lucky_moves_struct &lucky_moves, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves);


bool reload();  // �������, ������� ���������� ������� ��� ��� � ��������� true, ���� ������������ ���������� �� ���.
void set_players(player_type &player1, player_type &player2); // ������� ��������� ������� �������������, ��� ����� �������1, � ��� �������2.
void do_move(const player_type player); // �������, ������� ������ ���
void init_ship_coordinates_type (ship_coordinates *ship, int x); // ������� ��� ������������� ���� ship_coordinates
void Init_ships_type (ships_type); // ������� ��� ��������� ������������� ��������� ���� ships_type

void comp_ship_placing(ship_field comp_field);


							
	/* �������, ������� ������������ ���� ������� ������� �� �����������,
										��� turning_element - �������, ������� ���� ���������,
												axis - ���  ��������*/
void turn_element_to_horizontal(COORD &turning_element, const COORD axis);
void turn_element_to_vertical (COORD &turning_element, const COORD axis); // ������� ����������� ����������, ������ ��-���������


				/* �������, ������� ������������ ������� ������������� ��� �����������.
				   ���� �������� ������ ������ ������� �������(������ � �������).
				   COORD coords[] - ������ � ������������ �������, i - ������ �������.
				   ��������� ��������� �� �������, ������� �������� �������� �������� � ������������ ���� ������� �������.
				   ������� �������� ��� �������� ������������, ������������ � ��������������� �������� */;
bool turn_ship (ship_type &ship, int i, turning_side_type turn_side); // ������� �������� �������





/* check_ship_elements_with_value (...)
	������ ������� ���������� ���������� ���� ��������� ������� � ������������ ��������� �� ���� �������� ���,
   ���� ��� ������ ���� � ������������ ������� ����� ����� ��������, �� ������� ���������� true, ����� false.
	 ������ ������� ������������ ��������, ������� ������� ��� ��������� ���� ��� ����, ����, ��������������� ��������.
	 field - ���� �������� ���
	 *element - ��������� �� ������ ������� �������
	 ship - ��� �������
	 value - �������� � ������� ������������ �������� ������ ����
	 */

bool check_ship_elements_with_value (ship_field field, COORD *element, ship_sort ship, int value);






      /* void move_element
		�������, ������� �������� ��������� ������� (� ������ ���� - �� ����������� �������) �� ����
	      ������� �� ���������, ��������� �� ������� � �������� ����
		  element_coords - ���������� ��������
		  side - �������, � ������� ����� ����������� �������
				*/
void move_element (COORD &element_coords, move_side side);

		/* �������, ������� ������� ������� � ������������ ������� (������, �����, �����, ����)
		     *element - ��������� �� ������ ������� �������, ship - ��� �������,
			 side - �������, � ������� �� ������� �������.
              ������� �� ���������, ��������� �� ������� � �������� ���� �� �������� � �����.
              ������� �� ��������� ����� ��������� �� "�������" �������. */

void move_ship (COORD *element, ship_sort ship, move_side side);





 
void get_one_element_for_horizontal (COORD& element, const COORD axis, const int range); // ������� ������� ��������� ������ �������� ������� ������������ ��� �� �����������
void get_one_element_for_vertical (COORD& element, const COORD axis, const int range); // ������� ������� ��������� ������ �������� ������� ������������ ��� �� ���������

      /* �������, � ������� ������� �������� ���������� ����, ����, ���������������� ������� � ����������� �� ���
     axis (���) - ������ ������� ������� element;
	 ship - ��� �������.
	 turning_side_type - � ������ ������� ������������ ��� ������� �������(��������� ���������� ���������
	������� ��� ������� ������������ � �������������� ��������� � ������������ - ������)
	������� �� ���������: ��������� �� ��� � �������� ����.
	*/
void get_ship_element_coordinates (COORD *element, ship_sort ship, turning_side_type ship_position); 

           
   /* �������, ������� ������� ��� ��������� �������������� ��� ������������� �������.
      field - ���� ��� �������� ���, �� ������� ����� ������, 
	  buf[] - ������ ��� �������� ��������� ��������������
	  x - ������ ������
	  moves_found - ���-�� ��������� ��������������.
	�������, ��������� true, ���� ������ ���� �� ���� ���;
	������� ��������� false, ���� �� ������ �� ������ ����
	��� ����������� ����� � ������.
	  */

 
bool find_all_one_decker_moves (ship_field field, COORD buf[], int x, int& moves_found); 



  
/* ������� ������� ��� ��������� �������������� ��� �������������� �������.
        field - ���� �������� ���
        buf - �����, � ������� ����� ��������� ���������� ��������� ���������  
        ship - ��� ������� 
         x - ������ ������ �������, � ������� ����� ��������� ���������� ��������� ���������
         move_found -  ���������� ��������������, ������� ���� �������
        �������, ��������� true, ���� ������� ���� �� ���� �������������� �������.
         ������� ��������� false, ���� 1) ��� ������� - ������������
                                2) � ������ ������ ������ ��������
                                3) ����������� ����� � ������     */

bool find_all_many_decker_moves (ship_field field, COORD *buf, ship_sort ship, int x, int& moves_found);

 
       
   


/* ������� �������� ���� ������� � ����, �.�. ������ ������, �� ������� �� ����� ������,
� ������ ������� �������� ������, ������� ���� ��� ���� �������, ������ ���� ��� ��
��������� � ������� ������� */
bool get_element_from_field (ship_field field, COORD ship_coords);

// ������� �������� ������� � ����
bool get_ship_from_field(ship_field field, ship_coordinates* ship, int x);
 
 
/* ������ ������� "������" ������������ ������� �� ����.
       field - ���� ��� �������� ���.
	   ship - ������������ �������, ������� ���� ���������.
	   ������� ���������� true, ���� ������� ��� ������� ���������.
	   ���������� false, 1) ���� ������� ��������� �� ��������� ����
	                     2) ���� ������� �� ������������
						 */

bool add_one_decker_to_field (ship_field field, ship_type ship); 




      /* ������� ��������� ��������� ������� (��������������, ������������) �� ��� ����������� 
            ���� ������� ������������, �� ���������� ������ ��������������.   */
turning_side_type get_turning_side (ship_type ship);   


         /* ������� ��������� ������� ����������� ������� �� ����.
		    field - ���� ��� �������� ���
			ships - ������ � ���������
			*/
         
void ship_placing(ship_field field, ships_type ships); // ������� ��� ��������� ����������� �������� �� ����


      
 

 /*................................. �������, ���������� �� ������� ����...................*/

void write_field (ship_field field); // ������� ���� � ��������� ������, ��� field - ���� ��� �������� ���
        
         /* void delete_ship(...)
			������� ������� ������� �� ��������� �����������.
			output - ���������� ������
			table - ����� � ����. ���������
			start - ��������� ���������� ������ ����� (��� ���������� ������) */
void delete_ship (const HANDLE output, board table, COORD start); 
		/* ������� ������� �� ����� �������, ��� output - ��������� �� ���������� ������, text_attr - ������� �����/����,
	      start - ��������� ���������� ��������� �������� (�� ������), // size - ������ ������� (x � y) */

bool draw_square(const HANDLE output, const int text_attr, COORD start, COORD size);
bool draw_table (const HANDLE output, board table); // ������� ������ ����� �� ������, ��� table - ���������, ��������������� �����

void draw_window(const HANDLE output, coords Win_Coords,  char title[]); // ������� ������ ������� ���� �� �������� ����������� � ��� ���������
		    /*	void clear_window(...)
			������� ������� ���������� ���� �� �������� ����������� ����.
			output - ���������� ������
			Win_Coords - ���������� ����
			*/

void clear_window (const HANDLE output, coords Win_Coords); 
               	/* � ������� ���� ������� ����� �������� ��������� ���������� ����� ������ �� ����������� �����,
				  table - ����� � ����. ���������,
				  field_coords - ���������� ������ ��� ��� �������
				  */
COORD GetOffset (const HANDLE output, board table, const COORD field_coords);

                /* ������� ���������� ���������� ������ ��� ��� ������� �� ����������� �� ����������� �����,
				    � ����� �� ���� ������� ������� GetOffset,
					coordinates - ���������� �� ������
					table - ����� � ����������� ���������.*/
COORD GetXYbyOffset(COORD coordinates, board table);  
// ������� ������ ����������� ��������� �������� �������, ���������� ��� � *stars[] - ������ ���������� �� ������
void ship_stars (char *stars[]);
                   /* ������� ���������� ���� ������ ����� �� �������� �����������
				       table - ����� � ����. ���������
					   coordinates - ���������� ������ ��� ��� ������� */
int get_color_index (board table, COORD coordinates);

                   /* ������� ������ ������� � ��������� ����������� ����� 
					output - ���������� ������,
					table - ����� � ����. ���������
					color - ���� �������
					start - ���������� ������ ��� �������.
					*/

void draw_at_square(const HANDLE output, board table, int color, COORD start, void (*image)(char*[])); // ������� ������ ������� � ��������� ����������� �����

 /* ������� ���������, ��������� �� ���������� � �������� �����.
      ���������� true, ���� ���������� � �������� �����, ����� false
	   coordinates - ����������� ����������
         table - �����*/

bool InField (COORD coordinates, board table);

 /* ������� ���������, ��������� �� ����������� ���������� � �������� ������
	 ���������� true, ���� ���������� � �������� ������, ����� false.
	 coords - ���������� ������
	 size - ������ ������
	 check_coords - ����������� ����������
	 */

bool InSquare (COORD coords, COORD size, COORD check_coords);

		/* ������� �������� ������ �� ����� ������������ ������,
		   ���������� ��� ������� ������ �� ��������� �� ��� �����,
		   coords - ���������� ������ ��� �������� �������
		   table - ����� � ����������� ���������
		   color - ���� �������.
		   ���������� true, ���� ������� ������ �������, ����� false
		   */
		   
bool FillSquare(COORD coords, board table, int color); 

/*..................................�������, ���������� �� ������ � ��������...................*/

/*		ConsoleTitle (...)
		�������, ������� ��������� ��� ���� �������.
        output - ���������� ������(����������, �������)
		text[] - ������, ������� ����� ���������� (����� �� ������� �����)
		*/
void ConsoleTitle (const HANDLE output, const char text[]);   
							/* ������� ������������� ������ � �������� �����. 
								������� � ����� ��������� ������� 
								SetConsoleCursorPosition ( �� ����� ��������� ���������� ���� COORD).*/
void gotoxy (const HANDLE output, const int x, const int y);

     /* void ClearScreen(...)
		������� ��������� ����� (80*25) ��������� � ������������ ���������� �����/ ����, ���
	           color - �������� �����/ ����
			   sym - ������
			   */
void ClearScreen (int color, char sym);

void HideCursor(HANDLE output); // ������� ������ ������ �������

           
       /*   COORD click_move(...)
			������� ��������� COORD - ���������� ���������� ������ ������ ��� �������� �������
	        table - ����� � ����. ���������, ���� �������� ����� ��� ����, ����� ���������� - 
			����� ������ ������������ ��� ��������� ����.
			 */
COORD click_move(board table); // � ������� ���� ������� �������� ��� ������

/*....................................��������������� �������................................................*/

/*int abs_num(...)
 ������� ��������� ������ ������ �����, ��� x - ����� �����, ������ �������� ����� ��������� */
int abs_num(const int x) { return (x < 0) ? -x : x;} 
/* char_size(...)
������� ��������� ������ ������ ��� �������� ��������.
char x[] - ������
������������ ��������� ����������� �������.*/
int char_size (char x[]); 
		/*  check_sym_in_array (...)
			������� ���������, ��������� �� ������ � ������� ��������.
			���� ������ ���� � �������, �� ������� true, ����� false.
			sym - ������, ������� ���������
			arr[] - ������, � ������� ���������*/
bool check_sym_in_array (char sym, char arr[]);

/* void clear_lucky_moves(...)
	������� ��� ������� ��������� ���� lucky_moves_struct.
	����������� ���� ��������� ������ ��������� - 0;
	lucky_moves - ���������, ������� ���������� ��������.*/
void clear_lucky_moves(lucky_moves_struct &lucky_moves);

/* sort_lucky_moves_by_X(...)
	������� ��������� ������ ��������� lucky_moves �� X.
	����� ������� ������� ������������� � ������ �������.
	lucky_moves - ���������, ������� ���� �������������
	*/
void sort_lucky_moves_by_X(lucky_moves_struct &lucky_moves);

/* compare_two_COORD(...)
	������� ���������� ��� ��������� ���� Coord,
				���������� true, ���� ��� �����, ����� false
		first - ������ ���������
		second - ������ ���������*/
bool compare_two_COORD(const COORD first, const COORD second);


/*.................................�������, ������������ � �������� ����� ��������� */
     /* game_status check_game_status(...)
	 ������� ��������� � ���������� ��������� ����,
		   user_ships - ������� ������������
		   comp_ships - ������� ����������.
		   ���� ������� ������������, �� ������������ user_win,
			 ���� ������� ���������, �� ������������ comp_win,
			���� ����� �� ������� � ���� ����� ����������, ��
			  ������������ game
				*/
game_status check_game_status(ships_type user_ships, ships_type comp_ships);
 
/* ................................����������� �������..................................................*/

void swap_two_integers (short &first, short &second)
{
	int temp = first;
	first = second;
	second = temp;
}

	/* ������� ���������, ��������� �� ������� � ������ ���� */
bool check_ship_in_field(ship_type ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		if (!check_value_in_square(ship_p[i].coords))
			return false;
	return true;
}



              
void turn_element_to_horizontal(COORD &turning_element, const COORD axis) // ������� ������ �������� �� �����������
{
	turning_element.Y = turning_element.Y + (turning_element.X - axis.X);
	turning_element.X = axis.X;
}


void turn_element_to_vertical (COORD &turning_element, const COORD axis) // ������� ������ �������� �� ���������
{
	turning_element.X = turning_element.X + (turning_element.Y - axis.Y);
	turning_element.Y = axis.Y;

}

bool turn_ship (ship_type &ship, int i, turning_side_type turn_side) // ������� �������� �������
{
		
	
		void (*turn_function) (COORD&, const COORD);  // ������� �������� ���������� �������� �������

		ship_type temp = ship; // �������� ��������
		ship_coordinates *ship_p = &ship.one_d_ship;

		if (turn_side == horizontal) // ���� ������������ ����� �� �����������, �� �������� ���������� �� ������� �����������. �������
			turn_function = turn_element_to_horizontal;
		
		else // ����� ���� ������� �� ���������
			turn_function = turn_element_to_vertical;
		


		if (i > 1) // ���� ������� ������ �������������
	
			// �������� ������ ������� ������� ������ ��� ���
			while (--i != 0)
				 turn_function (ship_p[i].coords, ship_p[0].coords); // ������� ��� �������� ������ �������� �� ����������� � ���������

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

bool check_value_in_square (const COORD element) // ������� ���������, ��������� �� ���������� � ����� ����������� � �������� �����
{
	return (element.X >= 0 && element.X < height && element.Y >= 0 && element.Y < width);
}


bool check_ship_in_square (COORD *element, ship_sort ship) // ������� ���������, ��������� �� ������� � �������� �����
{
	for (int i = 0; i < ship; i++)
		if (!(check_value_in_square(element[i])))
			return false;
	return true;
}


void move_element (COORD &element_coords, move_side side)
{

	COORD temp = element_coords;
		switch (side)   // � ����������� �� ���� � ����� ������� �������, �������� ���������� ����������
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

	


void move_ship (ship_type &ship, move_side side) // �������, ������� ����������� ������� � ������������ �������
{
	ship_coordinates *ship_p = &ship.one_d_ship;
	ship_type temp = ship;
	
	for (int i = 0; i < ship.sort; i++) 
		move_element(ship_p[i].coords, side); // ������� ������ ������� �������

	if (!check_ship_in_field(ship))
		ship = temp;
}

void get_one_element_for_horizontal (COORD& element, const COORD axis, const int range) // ������� ������� ��������� ������ �������� ������� ������������ ��� �� �����������
{
	element.X = axis.X;
	element.Y = axis.Y + range;
}

void get_one_element_for_vertical (COORD& element, const COORD axis, const int range) // ������� ������� ��������� ������ �������� ������� ������������ ��� �� ���������
{
	element.X = axis.X + range;
	element.Y = axis.Y;
}

void get_ship_element_coordinates (COORD *element, ship_sort ship, turning_side_type ship_position) // ������� �������� ��������� ������� � ������������ ��� �������, � ����������� �� ��������� �������
{
	void (*get_one_element_coordinates) (COORD&, const COORD, const int); // ��������� �� �������, ������� ����� �������� ���������� ���������� �������� ������������ ���

	if (ship_position == horizontal) // �������� ������� � ����������� �� ��������� �������
		get_one_element_coordinates = get_one_element_for_horizontal;
	else
		get_one_element_coordinates = get_one_element_for_vertical;
	
	
	for (int i = 1; i < ship; i++)
		get_one_element_coordinates(element[i], element[0], i);

}

bool find_all_one_decker_moves (ship_field field, COORD buf[], int x, int& moves_found) // ������ ��� ���� ��� ������������� �������
{
	
	moves_found = 0;
	
	for (int i = 0; i < width; i++)
		for (int i2 = 0; i2 < height; i2++)
			if (field[i][i2] == EMPTY) // ���� ������ ������, �� �� ��� ����� ��������� ������������ �������
			{
				buf[moves_found].X = i;
				buf[moves_found].Y = i2;
				moves_found++;
				x--; 
				if (x == 0)
					return false;
			}

	if (moves_found > 0) // ���� �� ����� ���� �� ���� ���
		return true;
	return false;
}

 // ���������� ������ ���� � ������������ ������� � ������������ ���������.
bool check_ship_elements_with_value (ship_field field, COORD *element, ship_sort ship, int value)
{
	for (int i = 0; i < ship; i++)
		if (field[element[i].X][element[i].Y] != value)
			return false;
	return true;
}

bool add_to_coords (COORD* element, const COORD *added, int x) // ����������� added ������� element
{
	if (x <= 0)
		return false;
	for (int i = 0; i < x; i++)
		element[i] = added[i];
	return true;
}

void add_coords_to_ship_coordinates (ship_type &ship, COORD *element) // ����������� ���������� �� ������� element ���������� ���� COORD ������ ship_coordinates
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		ship_p[i].coords = element[i];
}


bool find_all_many_decker_moves (ship_field field, COORD *buf, ship_sort ship, int x, int& moves_found) // ������� ��������� �������������� ��� ������ ���� �������
{
	
	if (ship < two_decker) // ���� ������� ������ �������������..
		return false;
	if (x < 1)               // ���� ������ ������ ������ 1
		return false;
	
	
	COORD temp[four_decker]; // ���������� ��� �������� ��������� �������, ���� ��� �������� �� ����. ����� �������������� ��� ������ ���� ������� �� �������������.
	moves_found = 0; // ����������, ������� �������� �� ��������� ����
	for (int i = 0; i < height; i++)
	{
		
		temp[0].X = i;
		temp[0].Y = 0;
		
		while (check_value_in_square(temp[0]))  // ���� ������ ������� ������� (���) � �������� ����
		{
			for (int i2 = horizontal; i2 <= vertical; i2++) // ��������� ������� �� ����������� � ���������
			{
				get_ship_element_coordinates(temp, ship, turning_side_type(i2)); // ������� ���������� ��������� ��������� ������� 
			if (check_ship_in_square(temp, ship))  // ���� ������� ��������� � �������� ����              
			if (check_ship_elements_with_value (field, temp, ship, EMPTY)) // ���� ��� �������� ������� ��������� �� ������ ������� ����
			{
				add_to_coords (&buf[moves_found * ship], temp, ship);
				moves_found++;  
				x--;
				if (x = 0) // ���� � ������ ������ ��� �����
					return false;
            }
			}
			temp[0].Y++;
		}
	}
	
	return (moves_found > 0) ? true : false;
}


bool add_value_to_field (ship_field field, const int value, const COORD coordinates) // ��������� �������� �� ����
{
	if (check_value_in_square(coordinates)) // ���� �������� � ������ ����
	{
		field[coordinates.X][coordinates.Y] = value; 
		return true;
	}
	return false;
}

bool check_if_not_value_in_field (ship_field field, const int value, const COORD coordinates) // �������� ���������, ��� �� ������������� �������� �� ��������� ����������� ����
{
	if (check_value_in_square(coordinates)) // ���� ��������  � ������ ����
		if (field[coordinates.X][coordinates.Y] != value)
			return true;
	return false;
}



bool add_ship_element_to_field (ship_field field, COORD ship_coordinates) // ��������� ������� �� ����
{
	if (!add_value_to_field(field, SHIP_PART, ship_coordinates))  // ��������� �� ���� �������, ���� �� ������ ��������, �� ���������� false
		return false;
	
	COORD temp_square = {ship_coordinates.X - 1, ship_coordinates.Y - 1}; // ���������� ������, � ������� �� �������� ������ (����� �������)

	for (int i = 0; i < 8; i++) // ���� ����� ������ ������ ������
	{
		if (check_value_in_square(ship_coordinates))  // ���� ������� � ������ 
			if (check_if_not_value_in_field (field, SHIP_PART, temp_square))   // ���� �� �����, �� ������ ��������� �������
				add_value_to_field(field, AREA_NEAR_SHIP, temp_square);  // ������� ����� ����� �������

		 int current_side = i / 2;      // ������� � ������� �� ���� (�����, ����, ����, ����� - �� ������� �������)
		 move_element(temp_square, move_side(current_side)); // ��������
	}

	return true;
}

bool found_ship_near_area (ship_field field, COORD element_coords)     // ���� ������� ����� ������ � ����� ����� �������, ���� �� ������, �� true, ����� false
{
	COORD temp_square = {element_coords.X - 1, element_coords.Y - 1};
	
	for (int i = 0; i < 8; i++) // ���� ����� ������ ������ ������
	{
		if (check_value_in_square(temp_square)) // ���� ������� � ������ ����
			if (field[temp_square.X][temp_square.Y] == SHIP_PART)
				return true;
		int current_side = i / 2;      // ������� � ������� �� ���� (�����, ����, ����, ����� - �� ������� �������)
		move_element(temp_square, move_side(current_side)); // ��������
	}
	return false;
}



bool get_element_from_field (ship_field field, COORD ship_coords) // ������� �������� ������� � ���� ( � ����� �����������)
{
	if (!add_value_to_field(field, EMPTY, ship_coords))  // ������� ������� � ���� (����������� ������ ������ - ��� ��������)
		return false;
	
	COORD temp_square = {ship_coords.X - 1, ship_coords.Y - 1};
	for (int i = 0; i < 8; i++) // ���� ����� ������ ������ ������
	{
		
		if (check_value_in_square(ship_coords))  // ���� ������� � ������ ����
			if (!found_ship_near_area(field, temp_square))
					add_value_to_field(field, EMPTY, temp_square);
				int current_side = i / 2;      // ������� � ������� �� ���� (�����, ����, ����, ����� - �� ������� �������)
		move_element(temp_square, move_side(current_side)); // ��������
	}

	return true;
}

bool set_area_near_destroyed (ship_field field, COORD ship_coords)
{
	if (!check_value_in_square(ship_coords))
		return false;

		COORD temp_square = {ship_coords.X - 1, ship_coords.Y - 1};
	for (int i = 0; i < 8; i++) // ���� ����� ������ ������ ������
	{
		
		if (check_value_in_square(ship_coords))  // ���� ������� � ������ ����
			if (check_if_not_value_in_field (field, SHIP_PART, temp_square))   // ���� �� �����, �� ������ ��������� �������
				add_value_to_field(field, AREA_NEAR_DESTROYED, temp_square);
			 int current_side = i / 2;      // ������� � ������� �� ���� (�����, ����, ����, ����� - �� ������� �������)
		 move_element(temp_square, move_side(current_side)); // ��������
	}

	return true;
}

void set_area_near_ship_destroyed(ship_field field, ship_type ship)
{

	ship_coordinates *ship_p = &ship.one_d_ship;
	
	for (int i = 0; i < ship.sort; i++)
		set_area_near_destroyed (field, ship_p[i].coords);
}



 


bool get_ship_from_field(ship_field field, ship_coordinates* ship, int x) // ������� �������� ������� � ����
{
	if (x < 1)
		return false;
	for (int i = 0; i < x; i++)
		get_element_from_field (field, ship[i].coords); // �������� ������� � ����
	    ship[i].coords.X = 0;  // ����������� ������� �������� ��� �����������
		ship[i].coords.Y = 0;
	return true;
}




bool add_ship_to_field (ship_field field, ship_type& ship) // ��������� �������� ������� �� ����
{
	ship_coordinates *ship_p = &ship.one_d_ship;
	for (int i = 0; i < ship.sort; i++)
		add_ship_element_to_field(field, ship_p[i].coords);
	return true;
}



			/* ������� ��������� ������� �������������, ��� ����� ������� �������.
                ��� ���������� ��� ����, ����� ����������,��� ����� ������ ������
				���������� �������� ������, ������� ����� ������ ������. */
player_type set_current_player() 
{
	return (rand() % 2 == 0) ? user : pc;
}

void init_ship_coordinates_type (ship_coordinates *ship, int x) // ������� ��� ������������� ���� ship_coordinates
{
	if (x > 0)
		for (int i = 0; i < x; i++)
		{
			ship[i].alive = true;
			ship[i].coords.X = 0;
			ship[i].coords.Y = 0;
		}
}



void Init_ships_type (ships_type ships) // ������� ��� ��������� ������������� ��������� ���� ships_type
{
	for (int i = 0; i < 10; i++)
	{
		switch(i)
		{
		       /* ������ ������� - ������������*/
		case 0:
		case 1:
		case 2:
		case 3:
			ships[i].sort = one_decker;
			init_ship_coordinates_type(&ships[i].one_d_ship, one_decker);
			break;
			          /* ��� ������� - ������������ */
		case 4:
		case 5:
		case 6:
			ships[i].sort = two_decker;
			init_ship_coordinates_type(ships[i].two_d_ship, two_decker);
			break;
			          /* ��� ������� - ������������ */
		case 7:
		case 8:
			ships[i].sort = three_decker;
			init_ship_coordinates_type(ships[i].three_d_ship, three_decker);	

			break;
			         /* ���� ������� - ��������������� */
		case 9:
			ships[i].sort = four_decker;
			init_ship_coordinates_type(ships[i].four_d_ship, four_decker);
			break;
		}
	   ships[i].alive = true; // ��� ������� ���������� �����
	  
	}
}


turning_side_type get_turning_side_by_coords (const COORD first, const COORD second)
{
	return (first.X == second.X) ? horizontal : vertical;
}
	


turning_side_type get_turning_side (ship_type ship)   // ���������� ������������ ������� �� ��� �����������
{
	if (ship.sort == one_decker) // ���� ������� ������������, �� � ���� - �������������� ������
		return horizontal;
	else // ���� ������� �������������
	{
		ship_coordinates *ship_p = &ship.one_d_ship;
		return get_turning_side_by_coords(ship_p[0].coords, ship_p[1].coords);
	}
}


void ship_placing(ship_field field, ships_type ships) // ������� ����������� ��������
{
      
	int num_found;
	
	 for (int i = 9; i >=0; i--)
	  {
		  switch (ships[i].sort)
		  {
		  case four_decker:
			  {
				  COORD buf[200][4] = {0}; // ����� ��� �������� ��������� ��������� ���������������� �������
				  find_all_many_decker_moves(field, &buf[0][0], four_decker, 200, num_found); // ������� ��� ��������� ���������
				  add_coords_to_ship_coordinates(ships[i], buf[rand() % num_found]);
				  break;
			  }
		  case three_decker:
			  {
				  COORD buf[200][3] = {0};
				  find_all_many_decker_moves(field, &buf[0][0], three_decker, 200, num_found); // ������� ��� ��������� ���������
				  add_coords_to_ship_coordinates(ships[i], buf[rand() % num_found]);
				  break;
			  }
		  case two_decker:
			  {
				  COORD buf[200][2] = {0};
				  find_all_many_decker_moves(field, &buf[0][0], two_decker, 200, num_found); // ������� ��� ��������� ���������
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
	// ������� ������� �� ����� �������, ��� output - ��������� �� ���������� ������, text_attr - ������� �����/����,
	//  start - ��������� ���������� ��������� �������� (�� ������), // size - ������ ������� (x � y)
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

bool draw_table (const HANDLE output, board table) // ������� ������ �����, ��� start - ��������� ��������� �����
{
	COORD temp = table.start;

	int x = 0; 

	// ������ ���� �����
	for (int i = 0; i <= width; i++)
	{
		for (int i2 = 0; i2 < height; i2++)
		{
			temp.X = table.start.X + i2 * table.size.X;
			draw_square(output, table.text_attr[x], temp, table.size);
			(x == 0) ? x = 1 : x = 0; //������ ������� ����� ������
		}
		temp.Y = table.start.Y + i * table.size.Y;
		(x == 0) ? x = 1 : x = 0; // ��������� ��� ��������� ������
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
	char russian_letters[] = {"����������"};
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

void ConsoleTitle (const HANDLE output, const char text[])   // �������� �������� �������
{
	char buf[100];
	AnsiToOem(text, buf);
	SetConsoleTitle(buf);
}

void gotoxy (const HANDLE output, const int x, const int y) // ������� ������������� ������ � �������� �����. ������� � ����� ��������� ������� SetConsoleCursorPosition ( �� ����� ��������� ���������� ���� COORD);
{
	COORD temp = {{x}, {y}};
	SetConsoleCursorPosition(output, temp);
}

int char_size (char x[]) // ������� ��������� ������ ������ ��� �������� ��������
{
	int i = 0;
	while (x[i] != '\0') i++;
	return i;
}

void clear_window (const HANDLE output, coords Win_Coords) // ������� ������� ���������� ���� �� �������� ����������� ����
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

	void write_in_window(const HANDLE output, coords Win_Coords, char text[]) // ������� ������� ������ ������ � ����, ������ ���, ����� ��� �� �������� �� �������. ���� ����� ������� �� ������ �������, �� �� �����, ������� �������, ����������.
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
	
void draw_window(const HANDLE output, coords Win_Coords,  char title[]) // ������� ������ ������� ���� �� �������� ����������� � ��� ���������
{
	  SetConsoleTextAttribute(output, 15);
	
	  gotoxy (output, Win_Coords.x1, Win_Coords.y1);
      cout << char(218);      // ����� ������� ����
      gotoxy (output, Win_Coords.x2, Win_Coords.y1);
      cout << char(191);         // ������ ������� ����
      gotoxy (output, Win_Coords.x1, Win_Coords.y2);    
      cout << char(192);          // ����� ������ ����
      gotoxy (output, Win_Coords.x2, Win_Coords.y2);          
	  cout << char(217); // ������ ������ ����

	              // �������������� ������� 
    for (int count1 = Win_Coords.x1 + 1; count1 < Win_Coords.x2; count1++)
    {
          gotoxy (output, count1, Win_Coords.y1);    
		  cout << char(196); 
          gotoxy (output, count1, Win_Coords.y2);   
          cout << char(196);    
    }
				// ������������ �������
    for (int count2 = Win_Coords.y1 + 1; count2 < Win_Coords.y2; count2++)
    {
          gotoxy (output, Win_Coords.x1, count2);    
		  cout << char(179); 
	      gotoxy (output, Win_Coords.x2, count2);  
          cout << char(179); 
    }
                // ������ ��������� ���� �� ������ ����
	    char buf[50];
		AnsiToOem(title, buf);
		gotoxy (output, (Win_Coords.x1 + Win_Coords.x2) / 2 - char_size (title) / 2 + 1, Win_Coords.y1);
		cout << buf;

		clear_window(output, Win_Coords);
}
	
	

void ClearScreen (int color, char sym) // ��������� ����� ��������� ������������� �����
{
	LPDWORD realnum = 0; 
	COORD start = {0, 0}; // ������ �������� ���������

	FillConsoleOutputCharacter(output, sym, 80*25, start, realnum);   // �������� ���������;
	FillConsoleOutputAttribute(output, color, 80*25, start, realnum); // �������� ������
}


void ship_stars (char *stars[]) // ������ ����������� ��������� �������� ������� � ��������� ��� ��� ��������
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

COORD GetOffset (const HANDLE output, board table, const COORD field_coords)  // � ������� ���� ������� ����� �������� ��������� ���������� ����� ������ �� �����
{
	COORD return_value; // ������������ ��������
	
	return_value.X = table.start.X + table.size.X * field_coords.Y;
	return_value.Y = table.start.Y + table.size.Y * field_coords.X; 

	return return_value;
}

int get_color_index (board table, COORD coordinates) // ������� ���������� ���� ������ ����� �� �������� �����������
{
	
	if (coordinates.Y % 2 == 0)
		return (coordinates.X % 2 == 0) ? 1 : 0;
	else
		return (coordinates.X % 2 == 0) ? 0 : 1;
}

void draw_at_square(const HANDLE output, board table, int color, COORD start, void (*image)(char*[])) // ������� ������ ������� � ��������� ����������� �����
{
		
	int	color_index = get_color_index(table, start);  // ��� ������, �� ������� �� ����� ��������
		color = color | table.text_attr[color_index]; // ���� ������� ��������� � ����� ������

	start = GetOffset (output, table, start); // �������� ���������� �� ������

	SetConsoleTextAttribute(output, color);

	char *stars[2]; // ����������, ������� ����� ������� ����������� �������

    //ship_stars(stars); // �������� ��� �����������
	image(stars);

		    // ������ ��� �� ������
	for (int i = 0; i < 2; i++)
	{
		SetConsoleCursorPosition(output,  start);
		cout << stars[i];
		start.Y++;
	}
}

void draw_ships (const HANDLE output, ship_field field, board table, ships_type ships, player_type player) // ������� ������ ��� ������� �� ����
{
   
	for (int i = 0; i < 10; i++)
	{
		ship_coordinates *ship_p = &ships[i].one_d_ship;
					// ������ ����� �������
		for (int i2 = 0; i2 < ships[i].sort; i2++)
			draw_at_square(output, table, (player == user) ? user_ships_color : comp_ships_color, ship_p[i2].coords, &ship_stars);
		
	}
}

	
bool InField (COORD coordinates, board table) // ������� ���������, ��������� �� ���������� � �������� �����
{
	if (coordinates.X >= table.start.X && coordinates.X <= table.start.X + width * table.size.X -1) 
		if (coordinates.Y >= table.start.Y && coordinates.Y <= table.start.Y + height * table.size.Y -1)
			return true;
		
	return false;
}

bool InSquare (COORD coords, COORD size, COORD check_coords) // ������� ���������, ��������� �� ����������� ���������� � �������� ������
{
	int end_coords_X = coords.X + size.X - 1,
	    end_coords_Y = coords.Y + size.Y - 1;
	
	if (check_coords.X >= coords.X && check_coords.X <= end_coords_X)
		if(check_coords.Y >= coords.Y && check_coords.Y <= end_coords_Y)
			return true;
	return false;
}



COORD GetXYbyOffset(COORD coordinates, board table)  // ���������� ���������� �� ����� �� ����������� �� ������
{
	COORD return_value; // ������������ ��������
	return_value.Y = (coordinates.X - table.start.X) / table.size.X;
	return_value.X = (coordinates.Y - table.start.Y) / table.size.Y;
	return return_value;
}

bool FillSquare(COORD coords, board table, int color, player_type player) // ������� �������� ������ ������������ ������
{
	coords = GetOffset(output, table, coords); // �������� ���������� �� ����� (�����)

	LPDWORD realnum = 0;

	if (player == user)
		color = comp_ships_color | color;
	else
		color = user_ships_color | color;

	        // �������� ������ ����������� �� ���������
	for (int i = table.size.Y; i != 0; i--)
	{
		FillConsoleOutputAttribute(output, color, table.size.X, coords, realnum); // �������� �����������
		coords.Y++;
	}
	return true;
}
	
	


COORD click_move(board table) // � ������� ���� ������� �������� ��� ������
{
	INPUT_RECORD buf[1];   // ����� ��� �������� ��������� �������
	DWORD num;
    _MOUSE_EVENT_RECORD &MouseEvent = buf[0].Event.MouseEvent; // ������ �� ��������� ����

	while (true) // ���� ��� �� ������
	{
		ReadConsoleInput(input, buf, 1, &num); // ������ ��������� �������

		if (InField(MouseEvent.dwMousePosition, table)) // ���� ����� � ������ ����
		{

		    COORD square_field = GetXYbyOffset(MouseEvent.dwMousePosition, table); // ���������� ������ � ����
			COORD square = GetOffset(output, table, square_field); // �������� ��������� ���������� ������ �� ������
			
			FillSquare(square_field, table, SELECT_COLOR, user); // �������� �������, �� ������� �����

			while (InSquare(square, table.size, MouseEvent.dwMousePosition)) // ���� ����� ��������� � ������ ������
			{
				ReadConsoleInput(input, buf, 1, &num); // ������ ��������� �������

				if (MouseEvent.dwButtonState == 1) // ���� ������ ����� ������
				{
					while (MouseEvent.dwButtonState != 0)    // ���� ���� ������ �� ��������
						ReadConsoleInput(input, buf, 1, &num); // ������ ��������� �������

					if (InSquare(square, table.size, MouseEvent.dwMousePosition)) // ���� ������ ���� ��������� ��� �� ��� �� ������
					{
					FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // ��������� ������ ������ �����
					return GetXYbyOffset (MouseEvent.dwMousePosition, table); // ��������� ���������� ��� �������
					}
				}
			}

			FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // ���� ������ � ������, ��������� ������ �� ������ �����

		}
	}
	
}

COORD keyboard_move (board table) // � ������� ���� ������� �������� ��� �����������
{
	INPUT_RECORD buf[1];   // ����� ��� �������� ��������� �������
	DWORD num;
	char enter_keys[] = {"WwAaSsDd"};
	CHAR &KeyPressed = buf[0].Event.KeyEvent.uChar.AsciiChar;

	COORD square_field = {0, 0}; // ���������� ������ � ����
	FillSquare(square_field, table, SELECT_COLOR, user); // �������� �������

	do // ���� ��� �� ������
	{
		ReadConsoleInput(input, buf, 1, &num); // ������ ��������� �������

		if (check_sym_in_array(KeyPressed, enter_keys))
		{
			
			FillSquare(square_field, table, table.text_attr[get_color_index(table, square_field)], user); // ��������� ������ ������ �����
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

			FillSquare(square_field, table, SELECT_COLOR, user); // �������� �������
		}
	}while (KeyPressed != char(13));

	while (buf[0].Event.KeyEvent.bKeyDown)
		ReadConsoleInput(input, buf, 1, &num); // ������ ��������� �������
	return square_field;
}
		





void HideCursor(HANDLE output) // ������� ������� ������ � ������
{
	CONSOLE_CURSOR_INFO cursor = {1, false};
	SetConsoleCursorInfo(output, &cursor); 
}


// ������� ��������� �� ���������� �� ����� ������� 
bool check_ship_for_destroyed_parts (ship_type &ship, COORD shot_coords)
{
	ship_coordinates *ship_p = &ship.one_d_ship; // ��������� �� ������ ������� ������ �������

	           /* ������������� ��� �������� ������� � ��������� - �� ���������� �� ����� �� ��� ����� */
	for (int i = 0; i < ship.sort; i++)
		if (shot_coords.X  == ship_p[i].coords.X && shot_coords.Y == ship_p[i].coords.Y) // ���� ���������� �������� ��������� � ������������ ����� �������
		{
			if (ship_p[i].alive)
			{
				ship_p[i].alive = false; //�� ����� ������� ����������
				return true;
			}
			write_in_window(output, win_message_coords, "������ ����.����� ������� ��� ���������� ������� check_ship_for_destroyed_parts");
			return false;
		}
	return false;	// ���� ������� ������� �� ������ ������� �� ���������
}




     /* ������� ��������� ������� �� ������ �����������,
      ���� ��� ��� ����� ����������, �� �������
		���������� ���� ������� � ���������� true.
		���� ������� �� �������� ��� ���������, �� ������� ��������� true*/
		
bool check_ship_for_all_destroyed (ship_type &ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;
		/* ������������� ��� �������� �������*/
	for (int i = 0; i < ship.sort; i++)
		if (ship_p[i].alive)  // ���� ���� ���� ������� �����
			return false;

	ship.alive = false; // ���������� ���� �������, ���� ��� ��� �������� ����������
	return true;
}


     /* ��������� ������ ��������� ����������� */
char* destroy_message(ship_sort ship, player_type player)
{
	char* return_message;
	if (player == pc)
		return_message = "��� ������� ���������";
	else
		return_message = "�� ���������� ������� ����������";
	return return_message;
}
	


          /* ������ ������� ��������� ��� ������ �� ������������
			���� �� ��� ����� �� �� ������, �� ������� ��������� true,
			  ����� false */
bool check_move_for_correctness(const COORD move_coords, const ship_field enemy_field)
{
	if (enemy_field[move_coords.X][move_coords.Y] == MISS)
	{
		write_in_window(output, win_message_coords, "�� ��� ������ �� ��� ������");
		return false;
	}
	if (enemy_field[move_coords.X][move_coords.Y] == DESTROYED)
	{
		write_in_window(output, win_message_coords, "��� ����� ������� ��� ����������. ���� ������ ������.");
		return false;
	}
	return true;
}    


    /* ������� ������� ��������� ������� �� ����. �����*/
void write_ship_at_field(ship_type ship, board table, int color)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		draw_at_square(output, table, color, ship_p[i].coords, ship_stars);
}




     /* ��������� ��� � ��������� ���������� �������� */
ship_type* check_move(COORD move_coords, ship_field field, ships_type &enemy_ships, player_type player)
{
	if (field[move_coords.X][move_coords.Y] == SHIP_PART) // ���� �� ������ �� ����� �������
	{
		/* ���� � ������� �������� ��� �����*/
		for (int i = 0; i < 10; i++)
			if (check_ship_for_destroyed_parts(enemy_ships[i], move_coords)) // ���� ���������� ����� �������
			{
					if (check_ship_for_all_destroyed (enemy_ships[i])) // ���� ��������� ���� �������
					{
						write_in_window(output, win_message_coords, destroy_message(enemy_ships[i].sort, player));
						set_area_near_ship_destroyed(field, enemy_ships[i]); // ������� ������� ����� ��������� �������
					}
					break;
			}

			field[move_coords.X][move_coords.Y] = DESTROYED;   // ���������� ������� �� ����
						
			return &enemy_ships[i]; // ���������� ������ �� ��������� �������� �������
			
	}
	else
		if (field[move_coords.X][move_coords.Y] != DESTROYED)
		{
			  field[move_coords.X][move_coords.Y] = MISS; // ����
			  return 0;
		}
}


              /* ������� ������� ��������� �� ������*/
void write_result_in_table(COORD move_coords, ship_field field, board table, player_type player)
{
	

	
	
	if (field[move_coords.X][move_coords.Y] == MISS)
		draw_at_square(output, table, (player == user) ? comp_shot_color : comp_ships_color, move_coords, &miss_stars);
	else
		if (field [move_coords.X][move_coords.Y] == DESTROYED)
				draw_at_square(output, table, (player == user) ? comp_shot_color : comp_ships_color, move_coords, &destroyed_stars);

}


            
		/* ������� ������ ��� ������*/
bool do_user_move (ship_field enemy_field, ships_type &enemy_ships, board &enemy_table)
{

	bool return_value; // ����������� ��������
	bool game_ok;
	
	do{

		COORD move_coords ={0}; // ���������� ����
		move_coords = keyboard_move(enemy_table); // ���������� ����
		game_ok = check_move_for_correctness(move_coords, enemy_field);
		return_value = (check_move(move_coords, enemy_field, enemy_ships, user) != 0); 
		write_result_in_table(move_coords, enemy_field, enemy_table, pc);
	}while (!game_ok);

	return return_value;
	
}



       /*������� ��������� ��� ��������� "����������" ���� �� ������������ ���� � ���������� �� � ������ moves*/
bool check_all_moves (ship_field field, moves_type moves, int &num_of_moves)
{
	num_of_moves = 0; // ���-�� ��������� �����
	
	for (int i = 0; i < width; i++)
		for (int i2 = 0; i2 < height; i2++)
			    /* ���� ������ �� ����� "����" ��� "������������� �������" ��� "������� ����� ������������� ������� */
			if (field[i][i2] != MISS && field[i][i2] != DESTROYED && field[i][i2] != AREA_NEAR_DESTROYED)
			{
				moves[num_of_moves].X = i;
				moves[num_of_moves].Y = i2;
				num_of_moves++;
			}

	return (num_of_moves > 0); // ���� ���-�� ����� ������ ����, �� ������ true
}


    /* �������� ������ ����������, ������� �������� ��� ��������
	      � ���������� ��� � move_coords */
bool stupid_comp_algorithm (ship_field enemy_field, COORD &move_coords)
{
	moves_type all_moves; // ��� ��������� ����
	COORD comps_move = {0}; // ��������� ���
	int num_of_moves; // ���-�� �����

	check_all_moves(enemy_field, all_moves, num_of_moves); // ������� ��� ��������� ����

	move_coords = all_moves[rand() % num_of_moves]; // ��������� ������� �������� ���

	return true;
}


               /* ������� ��� ������� ��������� ������ ����������
			      ������������ ��� ����������, ���� ������ ������� ����� ����*/
COORD clever_no_lucky_moves(ship_field enemy_field, ships_type &enemy_ships, lucky_moves_struct &lucky_moves)
{
	COORD move_coords; // ��� ����������
	stupid_comp_algorithm(enemy_field, move_coords); // �������� �������� ���
	ship_type *destr_ship = check_move(move_coords, enemy_field, enemy_ships, pc); // ��������� ���	� ��������� ��������� �� ������ �������
    	if ( destr_ship != NULL)// ���� ��� �� "����" � �� ��������� ������������ �������	
			if (destr_ship->sort != one_decker)
				lucky_moves.arr[lucky_moves.num_of_moves++] = move_coords; // ��������� � ������ �������
	return move_coords;
}

/* ������� ��� ������� ��������� ������ ����������
			      ������������ �������, ���� ���� ����  ������� ���*/

void clever_one_lucky_move(const COORD element, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves)
{
	for (int i = to_right; i <= to_up; i++)
	{
		COORD temp = element; // ����� ������ � ����� ��������
		move_element(temp, (move_side)i); // �������� �������
		if (check_value_in_square(temp)) // ���� � �������� ����
			if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // � �� ��� ������ ������� ������
				all_clever_moves[num_of_moves++] = temp;
	}
	if (num_of_moves == 0)
		write_in_window(output, win_message_coords, "������ � ������� clever_one_lucky_move. �� ������ �� ���� ����� ���");

}


void sort_lucky_moves_by_X(lucky_moves_struct &lucky_moves)
{
	for (int i = 0; i < lucky_moves.num_of_moves; i++)
		for (int i2 = i + 1; i2 < lucky_moves.num_of_moves; i2++)
			if (lucky_moves.arr[i2].X < lucky_moves.arr[i].X)
				swap_two_integers(lucky_moves.arr[i2].X, lucky_moves.arr[i].X);
}

		
			/* ��������� ������� ���� �� Y */
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
	
/* ������� ��� ������� ��������� ������ ����������
			      ������������ �������, ���� ���� ��� � ����� ������� ����*/
void clever_two_more_moves (lucky_moves_struct &lucky_moves, ship_field enemy_field, COORD all_clever_moves[], int &num_of_moves)
{
	turning_side_type enemy_ship_position; // ��������� ������� ����� (��������������, ������������);

	enemy_ship_position = get_turning_side_by_coords(lucky_moves.arr[0], lucky_moves.arr[1]); // �������� ��� ���������

		
	if (enemy_ship_position == horizontal) // ���� ��������� ������� ��������������
	{
		sort_lucky_moves_by_Y(lucky_moves);     // ��������� �� X;

		/* �������� ��� ������� */
		for (int i = 0; i != 4; i+=2)
		{
			COORD temp = (i == 0) ? lucky_moves.arr[lucky_moves.num_of_moves-1] : lucky_moves.arr[0];;
			move_element(temp, (move_side)i); // �������� �������
			if (check_value_in_square(temp)) // ���� � �������� ����
				if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // � �� ��� ������ ������� ������
					all_clever_moves[num_of_moves++] = temp;
		}
		if (num_of_moves == 0)
			write_in_window(output, win_message_coords, "������ ����. �� ������� �� ������ ������ ����. ��������������. Clever_two_more_moves.");

	}
		else // �����, ���� ��������� ������� ������������
		{
			sort_lucky_moves_by_X(lucky_moves);     // ��������� �� Y;
					/* �������� ��� ������� */
			for (int i = 1; i != 5; i+=2)
			{
				COORD temp = (i == 1) ? lucky_moves.arr[lucky_moves.num_of_moves-1] : lucky_moves.arr[0];;
				move_element(temp, (move_side)i); // �������� �������
				if (check_value_in_square(temp)) // ���� � �������� ����
					if (enemy_field[temp.X][temp.Y] != MISS && enemy_field[temp.X][temp.Y] != AREA_NEAR_DESTROYED) // � �� ��� ������ ������� ������
						all_clever_moves[num_of_moves++] = temp;
			}
				if (num_of_moves == 0)
			write_in_window(output, win_message_coords, "������ ����. �� ������� �� ������ ������ ����. ������������. Clever_two_more_moves.");

		}
}




                  /*�������� ������ ����������*/
bool clever_comp_algorithm(ship_field enemy_field, ships_type &enemy_ships, COORD &move_coords)
{
	static lucky_moves_struct lucky_moves = {0}; // ��������� ������� �����
	ship_type* destr_ship;  // ��������� �� ������������ �������

	if (lucky_moves.num_of_moves == 0) // ���� ������� ����� ���, ��
	{
		move_coords = clever_no_lucky_moves(enemy_field, enemy_ships, lucky_moves); // �������� ������� ��� ��������� ����� �������
		return (lucky_moves.num_of_moves > 0); // ���� ���� ������� ��� (���������), �� ������ true
	}

	else // ���� ������� ����� ������ ������
	{
		COORD all_clever_moves[4]; // ������, ������� ����� ��������� ����� ���� ����� �����
		int num_of_moves = 0; // ���-�� ����� �����
		
		
		if (lucky_moves.num_of_moves == 1) // ���� ���� ������� ���, ��
			clever_one_lucky_move(lucky_moves.arr[0], enemy_field, all_clever_moves, num_of_moves); 

		else // ���� ������� ����� ������ 1, ��
			clever_two_more_moves(lucky_moves, enemy_field, all_clever_moves, num_of_moves);
			
		move_coords = all_clever_moves[rand() % num_of_moves]; // �������� ������� ��� �� ������� "����� �����"

		destr_ship = check_move(move_coords, enemy_field, enemy_ships, pc); // ��������� ���

			if (destr_ship != 0)  // ���� ������
			{
				lucky_moves.arr[lucky_moves.num_of_moves++] = move_coords; // ��������� � ������ ������� �����
				if (destr_ship->alive == false) // ���� ���� ������� ���������
						clear_lucky_moves(lucky_moves); // ������� ������ ������� �����
			}

	}
	return (destr_ship != 0);
}


bool do_comp_move(ship_field enemy_field, ships_type &enemy_ships, board &enemy_table)
{
	COORD move_coords; // ��������� ���������� ���
	move_result_type move_result; // ��������� ����
//	bool return_value = false;

	/*stupid_comp_algorithm(enemy_field, move_coords);
	check_move(move_coords, enemy_field, enemy_ships, pc); */
    bool return_value = clever_comp_algorithm(enemy_field, enemy_ships, move_coords); 
	write_result_in_table(move_coords, enemy_field, enemy_table, user); 

	return return_value;
}


    /* ������� ��������� ������ � ��������� �� ��������.
		���������� true, ���� ��� ������� ����������*/
bool check_ships_for_loose (const ships_type ships)
{
	for (int i = 0; i < 10; i++)
		if (ships[i].alive)
			return false;
	return true;
}


  
game_status check_game_status(ships_type user_ships, ships_type comp_ships) // ������� ��������� � ���������� ��������� ����
{
	if (check_ships_for_loose(comp_ships)) // ���� ��� ������� ���������� ����������
		return user_win;                 // ������������ �������
	else
		if (check_ships_for_loose(user_ships)) // ���� ��� ������� ������������ ����������
			return pc_win;                    // ��������� �������
		else
			return game;                      // ���������� ����
}

bool reload()  // �������, ������� ���������� ������� ��� ��� � ��������� true, ���� ������������ ���������� �� ���
{
    	write_in_window(output, win_message_coords, "�� ������ ������� �����? Y/N");
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




       /* ������� ������� ���� ����������, ��� win_coords - ���������� ����*/
void hello_window(const coords win_coords)
{
	
	
	draw_window(output, win_coords , "������� ���");
	clear_window(output, win_coords);
	write_in_window_line(win_coords, 1, "����� ���������� � ������� ���!");
	write_in_window_line (win_coords, 3, "��� ���� ��������������� �� �++. �������������� � Visual C++ 6.");
	write_in_window_line (win_coords, 6, "���� �������������� � ������� ����. ��� ����, ����� ������� ���, ���������� �������� ����� ������� ���� �� ������.");
	write_in_window_line (win_coords, 10, "*** - ����� �������");
	write_in_window_line (win_coords, 11, ". - �������� ��, ��� ������� ��� ������ ����");
	write_in_window_line (win_coords, 12, "xxx - �������� ��, ��� ���� ��������� � ����� �������");
	write_in_window_line (win_coords, 15, "������� -Enter- ��� ����, ����� ����������");
}

   /* ������� ��������� ����� �����������, ��� win_coords - ���������� ����*/
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

	while (input_buf[0].Event.KeyEvent.bKeyDown)    // ���� ������ �� ��������, ���������� ������ 
			ReadConsoleInput(input, input_buf, 1, &num);

	WriteConsoleOutput(output, buf, buf_size, buf_coord, &rect);
	
	
}


	/* ������� ���������� ���������� coords � ������������ �������
	   ���������� true, ���� ����� ������� ��������� � ���� �����������,
		 ����� false*/
bool get_ship_by_xy(const COORD coords, ship_type ship)
{
	ship_coordinates *ship_p = &ship.one_d_ship;

	for (int i = 0; i < ship.sort; i++)
		if (ship_p[i].coords.X == coords.X && ship_p[i].coords.Y == coords.Y)
			return true;
	return false;
}


       /* ������� ���������� ��������� �� ������� �� �����������
			���� ����� ������ �� ������� ����� � ���� �����������,
			  �� ������������ ��������� �� ����, ����� ����������� 0*/
int get_ships_by_xy(const COORD coords, ships_type ships)
{
	for (int i = 0; i <10; i++)
		if (get_ship_by_xy(coords, ships[i]))
			return i;
	return -1;
}



void delete_ship (const HANDLE output, board table, COORD start) // ������� ������� ������� �� ��������� �����������
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

				/*������� ��������� ������� �������� �� ��������� � �������� ����������� (��� ������*/

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
					write_in_window(output, win_message_coords, "������ ����. ������� get_move_side_by_mouse()");

}


              /* ������� ���������� ��� ��������� ���� first � second,
				���������� true, ���� ��� �����, ����� false*/
bool compare_two_COORD(const COORD first, const COORD second)
{
	return (first.X == second.X && first.Y == second.Y);
}



      /* ������� ���������, ����� �� �����, ���� �� ����� ��������� �������*/
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

		/* ������� ���������, ��������� �� ������ � ������� ��������.
			���� ������ ���� � �������, �� ������� true, ����� false*/
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

	
	COORD &MouseCoords = input_buf[0].Event.MouseEvent.dwMousePosition; // ���������� ����
	DWORD &MouseButton = input_buf[0].Event.MouseEvent.dwButtonState;  // ��������� ������ ����
	CHAR &KeyPressed = input_buf[0].Event.KeyEvent.uChar.AsciiChar;    // ������ ������� �������

	write_in_window(output, win_message_coords, "���������� ���� �������. ������� Esc, ����� ������ ����.");
	

	do{
		
			int cur_index = 0; // ������� ������� ������� (��� ������ �����)
			int selected_color = 15; // ���� ��������� �����
			write_ship_at_field(ships[cur_index], table, selected_color); // �������� ��� ����� ������ ���������

			do{
				ReadConsoleInput(input, input_buf, 1, &num);  // ������ ��������� � �������
				if (input_buf[0].EventType == KEY_EVENT) // ���� ������� ����������
				{
					if (input_buf[0].Event.KeyEvent.bKeyDown)    // ���� ������ ������, ��
					{
						if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_DOWN   // ���� ������ "������� ����"
							|| input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_UP) // ��� "������� �����"
						{
							write_ship_at_field(ships[cur_index], table, user_ships_color); // ������������ ���� �� ����������� �������
							if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_DOWN) // ���� ������ ������ "������� ����"
								(cur_index == 0) ? cur_index = 9 : cur_index--;
								else           // ���� ������ ������ "������� �����"
									(cur_index == 9) ? cur_index = 0 : cur_index++;

							write_ship_at_field(ships[cur_index], table, selected_color);  // �������� ����� ������ ���������
						}
					}


					if (KeyPressed == char(13))   // ���� ������ ������ "Enter"
						while (input_buf[0].Event.KeyEvent.bKeyDown)    // ���� ������ �� ��������, ���������� ������ 
													ReadConsoleInput(input, input_buf, 1, &num);
					if (KeyPressed == char(27))  // ���� ������ ������ "Esc"
						write_ship_at_field(ships[cur_index], table, user_ships_color); // ���������� ����� ������ ������


				}
					if (input_buf[0].EventType == MOUSE_EVENT) // ���� ������� ����
					{
						if (InField(MouseCoords, table)) // ���� ����� � �������� ����
							if (MouseButton == 1) // ���� ������ ����� ������ ����
							{
								COORD field_coords = GetXYbyOffset(MouseCoords, table); // ������� ������
								if (field[field_coords.X][field_coords.Y] == SHIP_PART) // ���� ��� ����� �������, ��
								{
									write_ship_at_field(ships[cur_index], table, user_ships_color); // ������������ ���� �� ����������� �������
									cur_index = get_ships_by_xy(field_coords, ships);
									break;
								}
							}
					}
			}while (KeyPressed != char(13) && KeyPressed != char(27));
			
		
			if (KeyPressed != char(27))
			{
					
						ship_type *our_ship = &ships[cur_index];
						write_ship_at_field(*our_ship, table, 13); // ������� ������� ����� ������
						get_ship_from_field(field, &our_ship->one_d_ship, our_ship->sort);

						ship_type ship_static = *our_ship;   // ��������� ���������� ��������� �������
						ship_type ship_dynamic = *our_ship;  // ��������� ������������ ��������� �������

					//	COORD start_coords = MouseCoords;
						while (true)
						{
							ReadConsoleInput(input, input_buf, 1, &num);

							if (input_buf[0].Event.KeyEvent.bKeyDown)
							{

							char enter_keys[] = {"WwAaSsDd"};
							
								if (check_sym_in_array(KeyPressed, enter_keys)) // ���� ������ � ����� ���������� ������ �� �����
								{
									move_side my_move_side = get_move_side_by_coords (KeyPressed); // ������� ������� �������� � ����������� �� ��������� ����
									draw_field_by_ship(ship_dynamic, table, field); // ������������ ���� �� ����������� �������
									move_ship(ship_dynamic, my_move_side);              // ������� �������
									write_ship_at_field(ship_dynamic, table, 13);   // ������ ������� �� ����� �����
								
								
								}	

									if (KeyPressed == char(13))
									{
										if (check_field_for_empty(field, ship_dynamic))
										{
											add_ship_to_field(field, ship_dynamic);
											*our_ship = ship_dynamic;
											write_ship_at_field(ship_dynamic, table, user_ships_color);
											while (input_buf[0].Event.KeyEvent.bKeyDown)    // ���� ������ �� ��������, ���������� ������ 
													ReadConsoleInput(input, input_buf, 1, &num);
										break;
										}
									}
									if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_BACK)
									{
										draw_field_by_ship(ship_dynamic, table, field); // ������������ ���� �� ����������� �������
										add_ship_to_field(field, ship_static);
										write_ship_at_field(ship_static, table, user_ships_color);
										break;
									} 

									if (input_buf[0].Event.KeyEvent.wVirtualKeyCode == VK_SHIFT)
									{
										draw_field_by_ship(ship_dynamic, table, field); // ������������ ���� �� ����������� �������
										turn_ship(ship_dynamic, ship_dynamic.sort, (turning_side_type)abs_num(ship_dynamic.ship_side - 1));
										write_ship_at_field(ship_dynamic, table, 13);   // ������ ������� �� ����� �����
									}
							}

								
						}
			}
							
	}while (KeyPressed != char(27)); 
	clear_window(output, win_message_coords);
}





void main()
{

bool game_continue = false; // ����������, ������� �������� �� ��, ���������� �� ����. ����� ��� ����, ����� ����������� ����������� ������� ��� ���. ����� true, ���� ���� ���� ����������.
bool hello = true; // ����������, ������� �������� �� �� - ���������� �� ���� ����������
	srand(time(0)); // ������������ ��������� ��������� ����� �� �������� �������.

	board user_table = {3, 2, 5, 2, 7 * 16, 8 * 16};    // ����������� ���� ������
	board comp_table = {3, 2, 40, 2, 6 * 16, 7 * 16};   // ����������� ���� ����������
	HideCursor(output);								    // ������ ������ � ������
	ClearScreen (SCREEN_COLOR, ':');                     // ������ ����� ������������ ������
	ConsoleTitle(output, "������� ���. �����: kornet."); // �������� ��������� ��� �������
	draw_window(output, win_message_coords, "���� ���������"); // �������� ���� ���������

	DWORD fdwMode = ENABLE_MOUSE_INPUT; 
	SetConsoleMode(input, fdwMode); //���� ����������� ����� � �����

	
do
{
	game_status status = game; // ������ ���� - ���������� ����.
	player_type current_player = set_current_player(); // ��������� �������� ������
	ship_field user_field = {0}; // ���� ������������
	ship_field comp_field = {0}; // ���� �����
	ships_type user_ships, // ������� ������������
		       comp_ships; // ������� �����

	Init_ships_type (user_ships); // ������������� �������� ������������
	Init_ships_type (comp_ships); // ������������� �������� ����������
	
	ship_placing(user_field, user_ships); // ��������� ����������� �������� ������������
	ship_placing(comp_field, comp_ships); // ��������� ����������� �������� �����

	draw_table(output, user_table);  // ���������� ����������� ���� ������������
	draw_table (output, comp_table);	// ���������� ����������� ���� ����������
	if (hello) // ���� ����� �������� ���� �����������, ��
	{
		hello_window_driver(hello_window_coords);
		hello = false;
	}
	draw_ships(output, user_field, user_table, user_ships, user); // ���������� ������� ������������
	user_ship_replace(user_field, user_ships, user_table);  // ����������� ������������ ����������� �������


	do{
		if (current_player == user)   // ���� ������� ����� - ������������
		  while (do_user_move(comp_field, comp_ships, comp_table)); // �� ������ ���, ���� ������� ����� �������� �����
		else                            // ����� ������� ����� - ����������
			while (do_comp_move(user_field, user_ships, user_table));  // �� ������ ���, ���� ������� ����� �������� �����
		current_player = (player_type)abs_num(current_player-1);  // ������ �������� ������
	    status = check_game_status(user_ships, comp_ships); // �������� ��������� ����
	}while (status == game); // ���������� ���� ����� �� �������
  
 game_continue = reload(); // ���������� � ������� ������� reload() - ����� �� ���������� ����?
}while (game_continue); // ���������� , ���� ������������ ����������� ���������� ����


}