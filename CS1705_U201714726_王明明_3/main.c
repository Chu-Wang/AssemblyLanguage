#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RetMenu -1
#define N 10
#define MaxS 65535
//采用链表的形式,将所有的商品进行编号
typedef struct
{
	char ProductName[10];//商品名称
	char Discount;//折扣
	short ProductPrice;//进价
	short SellingPrice;//售价
	short StockNumber;//进货总数
	short SaleNumber;//已售数目
	short rec;//推荐度
}PRO;
extern  void Search_Pro(PRO *ProductArray, char*pro, int len, int *flag);
extern  void Recommend_All_Index(PRO *ProductArray);
extern  void Rank_Recom_Score(PRO *ProductArray);
void ShowMenu(int AUTH);
void DividingLine();
void PrintfString(char* s);
void PrintfNumber(short x);
int Search(PRO *ProductArray);
void ShowProLogin(PRO ProductArray);
void ShowProUnlogin(PRO pro);
void ShowAllProduct(PRO *ProductArray);
void Assignment(PRO *ProductArray,int n, char*ProductName,  char Discount, short ProductPrice, short SellingPrice, short StockNumber, short SaleNumber, short rec);
void EditProduct(PRO *pro);

int main()
{
	int i;
	int AUTH = 0;//初始AUTH==0,未登录
	PRO ProductArray[N];//商品链表
	char InputInformation[100];//输入信息数组大小,可以保存输入的用户名密码
	char Username[] = "WANGM";//已有的用户名
	char Password[] = "TEST";//已有的密码
	char op;
	//将所有的商品进行赋值操作,即初始化
	Assignment(ProductArray,0,"PEN", 10, 35, 56, 150, 25, 43);
	Assignment(ProductArray,1, "BOOK", 9, 12, 50, 25, 5, 75);
	for (i = 2; i <= N - 2; i++){
		Assignment(ProductArray,i, "TEMPVALUE", 8, 15, 20, 30, 2, 41);
	}
	Assignment(ProductArray,N-1, "BAG", 10, 35, 55, 500, 27, 39);
	while (1)
	{
		printf("*****THE SHOP IS SHOP_ONE*****\n");//打印商店名称
		DividingLine();//分割线
		printf("PLEASE INPUT YOUR NAME:\n");//提示输入用户名
		gets_s(InputInformation, 6);//关于gets_s的用法,CSDN详解
		if (!InputInformation[0]) AUTH = 0;//回车的情况
		else if (!InputInformation[1] && InputInformation[0] == 'q') return 0;//输入为q的情况
		else if (strcmp(InputInformation, Username) != 0)//首先比较两个字符串的大小是否相等,不相等直接提示错误
		{
			printf("The Name Is Wrong!");
			continue;//继续要求输入用户名
		}
		else
		{
			printf("The Name Is Right!\n");
			printf("PLEASE INPUT YOUR PASSWORD:\n");//提示输入密码
			scanf_s("%s", InputInformation, 5);//限制读取5个字节,具体用法已收藏至CSDN
			if (!strcmp(InputInformation, Password)){
			AUTH = 1;//比较的结果相等,则登陆成功
			printf("Landed Successfully!\n");
			} 
			else {//比较结果不相等则提示密码错误
				printf("The PWD Is Wrong!\n");
				continue;//继续输入密码
			}
		}
		while (1)
		{
			ShowMenu(AUTH);//调用ShowMenu函数,参数为AUTH,即登陆状态
			printf("Please input your selection[1-%d]:", AUTH ? 6 : 2);
			rewind(stdin);//用于将文件指针重新指向文件的开头,同时清除和文件流相关的错误和eof标记
			op = getchar();
			rewind(stdin);
			if (op == '\n') break;//如果仅回车,返回上一级,要求输入用户名
			if (op > '2'&&AUTH != 1)
			{
				//如果未登录输入的数字不符合，那么将会提示错误
				printf("The number is wrong,please input again!\n");
				continue;//继续输入选择
			}
			switch (op)
			{
			case '1':
			{
				int num;
				num=Search(ProductArray);//查看商品信息的第一个步骤,找到该商品
				if (num > 0)//根据返回值,判断是否找到
				{
					if (AUTH == 1)//此时为登陆状态,与未登录状态显示内容略有不同
						ShowProLogin(ProductArray[num - 1]);
					else ShowProUnlogin(ProductArray[num - 1]);
				}
				break;
			}
			case '2':
			{
				int num;
				if (!AUTH)
					return 0;//对应未登录状态时的退出,即登录状态下的数字6
				else
				{
					num=Search(ProductArray);
					if(num>0)
					EditProduct(&ProductArray[num-1]);
					break;
				}
			}
			case '3':
			{
				Recommend_All_Index(ProductArray);//对所有的商品进行推荐度的计算
				break;
			}
			case '4':
			{
				Rank_Recom_Score(ProductArray);//进行排序
				break;
			}
			case '5':
			{
				ShowAllProduct(ProductArray);//打印所有商品的信息
				//Display_All_Good(ProductArray, PrintfString, PrintfNumber,showPRO_ASM);
				break;
			}
			case '6':
				return 0;//退出程序
			default:
				printf("Input Error,please input again!\n");
				continue;
			}
		}

	}

	return 0;
}

void ShowMenu(int AUTH)
{
	DividingLine();
	if (AUTH)//登陆状态打印所有的菜单
	{
		printf("1==Query product information\n");     
		printf("2==Modify product information\n");
		printf("3==Calculate the recommendation\n");
		printf("4==Calculate the recommendation rank\n");  
		printf("5==Output all commodity information\n");
		printf("6==Exit(Input Enter to return)\n");
	}
	
	else//未登录状态仅打印一部分菜单
	{
		printf("1==Query product information\n");
		printf("2==Exit(Input Enter to return)\n");
	}
	DividingLine();//分割线
}
void DividingLine()//分割线,为了美观
{
	printf("**********************************************************\n");
}
void PrintfString(char*s)
{
	printf("%s", s);//主要用来打印商品的名称
}
void PrintfNumber(short x)
{
	printf("%d", x);//打印商品的数字信息
}
void Assignment(PRO *ProductArray,int n, char*ProductName, char Discount, short ProductPrice, short SellingPrice, short StockNumber, short SaleNumber, short rec)
{
	//该函数用来赋初值
	strcpy_s(ProductArray[n].ProductName,10,ProductName);
	ProductArray[n].Discount = Discount;
	ProductArray[n].ProductPrice = ProductPrice;
	ProductArray[n].SellingPrice = SellingPrice;
	ProductArray[n].StockNumber = StockNumber;
	ProductArray[n].SaleNumber = SaleNumber;
	ProductArray[n].rec = rec;
}
int Search(PRO *ProductArray)//搜索商品的函数
{
	int flag = -1;//首先用flag表示未找到该商品
	char pro[12];
	int len;
	while (1)
	{
		printf("Please Input The Good You Want!\n");
		rewind(stdin);//用于将文件指针重新指向文件的开头,同时清除和文件流相关的错误和eof标记
		gets_s(pro, 11);
		for (len = 0; pro[len]; len++);
		if (!pro[0]) return RetMenu;
		Search_Pro(ProductArray, pro, len, &flag);
		if (flag == 0)
		{
			//商品未找到
			printf("Product has not been found!\n");
			DividingLine();
		}
		else break;
	}
	return flag;
}

void EditProduct(PRO *pro)
{
	//用来编辑商品信息
	char InputInformation[6];//输入的商品信息
	short x;
	while (1)//利用循环的模式,每次修改一项内容 
	{
		printf("Discount:%d->",pro->Discount);
		gets_s(InputInformation, 6);
		if (!InputInformation[0]) break;//如果输入回车,则修改下一项内容
		else if (ChectInput(InputInformation, &x,10))
		{
			pro->Discount = x;//进行修改折扣价格
			break;
		}
	}
	while (1)
	{
		printf("PURCHASE:%d->", pro->ProductPrice);//同上一个模块
		gets_s(InputInformation, 6);
		if (!InputInformation[0]) break;
		else if (ChectInput(InputInformation, &x, MaxS))
		{
			pro->ProductPrice = x;
			break;
		}
	}
	while (1)
	{
		printf("SALE PRICE:%d->", pro->SellingPrice);
		gets_s(InputInformation, 6);
		if (!InputInformation[0]) break;
		else if (ChectInput(InputInformation, &x, MaxS))
		{
			pro->SellingPrice = x;
			break;
		}
	}
	while (1)
	{
		printf("STOCK NUMBER:%d->", pro->StockNumber);
		gets_s(InputInformation, 6);
		if (!InputInformation[0]) break;
		else if (ChectInput(InputInformation, &x, MaxS))
		{
			pro->StockNumber = x;
			break;
		}
	}
}
int ChectInput(char *input, short *x, int max)
{
	//修改信息时用来判断输入是否合法
	int i;
	short temp=0,s=0;
	for (i = 0; input[i]; i++)
	{
		if (input[i] >= '0'&&input[i] <= '9')
		{
			temp = input[i] - '0';
			s *= 10;
			s += temp;
		}
		else return 0;
	}
	if (s <= max)
	{
		*x = s;
		return 1;
	}
	else return 0;
}
void ShowAllProduct(PRO *ProductArray)
{
	//输出所有商品的信息
	int i = 0;
	int j = 1;
	for (i = 0; i < N; i++)
	{
		if (!i)
		{
			printf("1:\n");
		}
		else 
		{
			if (ProductArray[i].rec < ProductArray[i - 1].rec)
				j++;
			printf("%d:\n", j);
		}
		ShowProLogin(ProductArray[i]);
	}
}

void ShowProLogin(PRO pro)
{
	//登陆状态下打印内容
	printf("%s\n", pro.ProductName);
	printf("%hd,%hd,%hd,", pro.Discount, pro.ProductPrice, pro.SellingPrice);
	printf("%hd,%hd,%hd\n", pro.StockNumber, pro.SaleNumber, pro.rec);
}
void ShowProUnlogin(PRO pro)
{
	//未登陆状态下打印内容
	printf("%s\n", pro.ProductName);
	printf("%hd,%hd,%hd,", pro.Discount, pro.ProductPrice, pro.SellingPrice);
	printf("%hd,%hd,", pro.StockNumber, pro.SaleNumber);
	//推荐度的输出
	if (pro.rec > 100) putchar('A');
	else if(pro.rec > 50)putchar('B');
	else if(pro.rec>10) putchar('C');
	else putchar('F');
	printf("\n");
}
