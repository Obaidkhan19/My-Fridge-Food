USE [master]
GO
/****** Object:  Database [Fridgefood]    Script Date: 6/25/2023 12:51:29 PM ******/
CREATE DATABASE [Fridgefood]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Fridgefood', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Fridgefood.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Fridgefood_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Fridgefood_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Fridgefood] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Fridgefood].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Fridgefood] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Fridgefood] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Fridgefood] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Fridgefood] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Fridgefood] SET ARITHABORT OFF 
GO
ALTER DATABASE [Fridgefood] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Fridgefood] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Fridgefood] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Fridgefood] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Fridgefood] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Fridgefood] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Fridgefood] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Fridgefood] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Fridgefood] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Fridgefood] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Fridgefood] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Fridgefood] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Fridgefood] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Fridgefood] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Fridgefood] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Fridgefood] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Fridgefood] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Fridgefood] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Fridgefood] SET  MULTI_USER 
GO
ALTER DATABASE [Fridgefood] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Fridgefood] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Fridgefood] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Fridgefood] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Fridgefood] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Fridgefood] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Fridgefood] SET QUERY_STORE = OFF
GO
USE [Fridgefood]
GO
/****** Object:  Table [dbo].[Bin]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [float] NULL,
	[QuantityUnit] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[FridgeItemId] [int] NULL,
	[FridgeId] [int] NULL,
	[Label] [varchar](50) NULL,
	[PurchaseDate] [date] NULL,
	[ExpiryDate] [date] NULL,
	[IsFrozen] [bit] NULL,
 CONSTRAINT [PK_Bin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConsumptionLog]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumptionLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LogData] [varchar](max) NULL,
	[Date] [datetime] NULL,
	[Quantity] [float] NULL,
	[QunatityUnit] [varchar](50) NULL,
	[FridgeItemId] [int] NULL,
	[UserId] [int] NULL,
	[FridgeId] [int] NULL,
 CONSTRAINT [PK_ConsumptionLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fridge]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fridge](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[ConnectionId] [varchar](100) NULL,
	[AllDailyConsumption] [bit] NULL,
	[FreezerType] [int] NULL,
 CONSTRAINT [PK_Fridge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FridgeItem]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FridgeItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Image] [varchar](max) NULL,
	[ItemUnit] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[FreezingTime] [int] NULL,
	[FridgeTime] [int] NULL,
	[ExpiryReminder] [int] NULL,
	[LowStockReminder] [float] NULL,
	[LowStockReminderUnit] [varchar](50) NULL,
	[DailyConsumption] [float] NULL,
	[DailyConsumptionUnit] [varchar](50) NULL,
	[FridgeId] [int] NULL,
	[ItemId] [int] NULL,
 CONSTRAINT [PK_FridgeItem_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FridgeUser]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FridgeUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FridgeId] [int] NULL,
	[UserId] [int] NULL,
	[Role] [varchar](50) NULL,
 CONSTRAINT [PK_FridgeUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ingredient]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingredient](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [float] NULL,
	[Unit] [varchar](50) NULL,
	[FridgeItemId] [int] NULL,
	[RecipeId] [int] NULL,
 CONSTRAINT [PK_Ingredient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Image] [varchar](max) NULL,
	[Category] [varchar](50) NULL,
	[FreezingTime] [int] NULL,
	[FridgeTime] [int] NULL,
	[ItemUnit] [varchar](50) NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recipe]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recipe](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Image] [varchar](max) NULL,
	[Servings] [int] NULL,
	[FridgeId] [int] NULL,
 CONSTRAINT [PK_Recipe] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecipeNotification]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeNotification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](max) NULL,
	[Body] [varchar](max) NULL,
	[Date] [datetime] NULL,
	[MealDate] [datetime] NULL,
	[MealTime] [varchar](50) NULL,
	[Reply] [varchar](50) NULL,
	[SenderId] [int] NULL,
	[RecieverId] [int] NULL,
	[FridgeId] [int] NULL,
	[RecipeId] [int] NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingList]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Header] [varchar](500) NULL,
	[Body] [varchar](500) NULL,
	[Date] [datetime] NULL,
	[FridgeId] [int] NULL,
	[SenderId] [int] NULL,
	[ReplierId] [int] NULL,
	[FridgeItemId] [int] NULL,
 CONSTRAINT [PK_ShoppingList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stock]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Label] [varchar](50) NULL,
	[Quantity] [float] NULL,
	[QuantityUnit] [varchar](50) NULL,
	[PurchaseDate] [date] NULL,
	[ExpiryDate] [date] NULL,
	[IsFrozen] [bit] NULL,
	[FridgeItemId] [int] NULL,
 CONSTRAINT [PK_Stock] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 6/25/2023 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bin] ON 

INSERT [dbo].[Bin] ([Id], [Quantity], [QuantityUnit], [Date], [FridgeItemId], [FridgeId], [Label], [PurchaseDate], [ExpiryDate], [IsFrozen]) VALUES (1018, 17, NULL, CAST(N'2023-05-20T12:44:58.523' AS DateTime), 1006, 1, N'Chicken - 4556', CAST(N'2023-05-20' AS Date), CAST(N'2023-05-20' AS Date), 0)
INSERT [dbo].[Bin] ([Id], [Quantity], [QuantityUnit], [Date], [FridgeItemId], [FridgeId], [Label], [PurchaseDate], [ExpiryDate], [IsFrozen]) VALUES (2024, 22, NULL, CAST(N'2023-06-07T15:47:29.823' AS DateTime), 7139, 2, N'Shami kebab - 8082', CAST(N'2023-05-29' AS Date), CAST(N'2023-06-01' AS Date), 0)
INSERT [dbo].[Bin] ([Id], [Quantity], [QuantityUnit], [Date], [FridgeItemId], [FridgeId], [Label], [PurchaseDate], [ExpiryDate], [IsFrozen]) VALUES (2029, 1, NULL, CAST(N'2023-06-11T11:55:10.860' AS DateTime), 4103, 2, N'Banana - 6836', CAST(N'2023-05-20' AS Date), CAST(N'2023-05-26' AS Date), 0)
INSERT [dbo].[Bin] ([Id], [Quantity], [QuantityUnit], [Date], [FridgeItemId], [FridgeId], [Label], [PurchaseDate], [ExpiryDate], [IsFrozen]) VALUES (2030, 3, NULL, CAST(N'2023-06-11T12:58:07.050' AS DateTime), 4103, 2, N'Banana - 476', CAST(N'2023-06-11' AS Date), CAST(N'2023-06-11' AS Date), 0)
INSERT [dbo].[Bin] ([Id], [Quantity], [QuantityUnit], [Date], [FridgeItemId], [FridgeId], [Label], [PurchaseDate], [ExpiryDate], [IsFrozen]) VALUES (2031, 5, NULL, CAST(N'2023-06-11T12:58:26.167' AS DateTime), 4103, 2, N'Banana - 7230', CAST(N'2023-06-11' AS Date), CAST(N'2023-06-10' AS Date), 0)
SET IDENTITY_INSERT [dbo].[Bin] OFF
GO
SET IDENTITY_INSERT [dbo].[ConsumptionLog] ON 

INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (7, N'Sheharyar has used 1 Tomato', CAST(N'2023-06-10T18:38:04.387' AS DateTime), 1, NULL, 8, 2, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (2095, N'Obaid has used 1 Tomato', CAST(N'2023-06-11T18:38:04.387' AS DateTime), 1, NULL, 8, 1, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (6144, N'Obaid khan has used 5  Apple', CAST(N'2023-03-11T16:44:38.217' AS DateTime), 5, N'null', 6109, 1, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (6145, N'Obaid khan has used 2  Apple', CAST(N'2023-03-14T16:44:38.217' AS DateTime), 2, N'null', 6109, 1, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (6155, N'Obaid khan has used 8  Egg', CAST(N'2023-04-11T16:44:38.217' AS DateTime), 8, NULL, 9148, 1, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (6165, N'Obaid khan has used 2  Tomato', CAST(N'2023-05-12T12:35:19.197' AS DateTime), 2, N'null', 8, 1, 2)
INSERT [dbo].[ConsumptionLog] ([Id], [LogData], [Date], [Quantity], [QunatityUnit], [FridgeItemId], [UserId], [FridgeId]) VALUES (6166, N'Obaid khan has used 3  Tomato', CAST(N'2023-06-12T12:35:23.270' AS DateTime), 3, N'null', 8, 1, 2)
SET IDENTITY_INSERT [dbo].[ConsumptionLog] OFF
GO
SET IDENTITY_INSERT [dbo].[Fridge] ON 

INSERT [dbo].[Fridge] ([Id], [Name], [ConnectionId], [AllDailyConsumption], [FreezerType]) VALUES (1, N'Mudassir fridge', N'ABC123', 1, 1)
INSERT [dbo].[Fridge] ([Id], [Name], [ConnectionId], [AllDailyConsumption], [FreezerType]) VALUES (2, N'Obaid fridge', N'ABC124', 1, 3)
INSERT [dbo].[Fridge] ([Id], [Name], [ConnectionId], [AllDailyConsumption], [FreezerType]) VALUES (3, N'Sahid fridge', N'ABC324', 1, 3)
INSERT [dbo].[Fridge] ([Id], [Name], [ConnectionId], [AllDailyConsumption], [FreezerType]) VALUES (4, N'Azeem fridge', N'ABC789', 0, 4)
SET IDENTITY_INSERT [dbo].[Fridge] OFF
GO
SET IDENTITY_INSERT [dbo].[FridgeItem] ON 

INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (1, N'Mutton', N'Mutton.png', N'kgorg', N'Meat', 300, 2, 3, 0, NULL, 0, NULL, 2, 1)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (8, N'Tomato', N'Tomato.png', N'nounit', N'Vegetable', 30, 7, 5, 4, NULL, 2, NULL, 2, 16)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (1006, N'Chicken', N'Chicken.png', N'nounit', N'Meat', NULL, 3, 3, 1, NULL, 3, NULL, 1, 2)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (1007, N'Bread', N'Bread.png', N'nounit', N'Bakery', NULL, 7, 3, 3, NULL, 5, NULL, 1, 3)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (4099, N'Yogurt', N'Yogurt.png', N'nounit', N'Dairy', 10, 14, 4, 4, NULL, 1, NULL, 2, 7)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (4103, N'Banana', N'Banana.jfif', N'nounit', N'Fruit', NULL, 6, 3, 6, NULL, 1, NULL, 2, 10)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (6109, N'Apple', N'Apple.png', N'nounit', N'Fruit', NULL, 15, 4, 4, NULL, 2, NULL, 2, 8)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (7139, N'Shami kebab', N'Shami kebab.jpg', N'nounit', N'Cooked', NULL, 3, 4, 0, NULL, 2, NULL, 2, 1106)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (7141, N'Banana', N'Banana.jfif', N'nounit', N'Fruit', NULL, 6, 4, 0, NULL, 0, NULL, 2033, 10)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (8139, N'Tomato', N'Tomato.png', N'nounit', N'Vegetable', 365, 5, 4, 0, NULL, 0, NULL, 1, 16)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (8140, N'Yogurt', N'Yogurt.png', N'lorml', N'Dairy', 10, 14, 4, 0, NULL, 0, NULL, 1, 7)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9148, N'Egg', N'Eggs.png', N'nounit', N'Eggs', NULL, 30, 4, 6, NULL, 3, NULL, 2, 4)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9206, N'Fish', N'Fish.png', N'nounit', N'Seafood', 100, 3, 4, NULL, NULL, NULL, NULL, 2, 9)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9207, N'Condense Milk', N'Condense Milk.png', N'nounit', N'Dairy', 250, 2, 4, NULL, NULL, NULL, NULL, 2, 11)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9208, N'Milk', N'Milk.png', N'nounit', N'Dairy', NULL, 4, 4, NULL, NULL, NULL, NULL, 2, 5)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9209, N'Dough', N'dough.png', N'nounit', N'Other', NULL, 4, 4, NULL, NULL, NULL, NULL, 2, 1095)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9210, N'Jam', N'Jam.png', N'nounit', N'Other', NULL, 180, 4, NULL, NULL, NULL, NULL, 2, 1097)
INSERT [dbo].[FridgeItem] ([Id], [Name], [Image], [ItemUnit], [Category], [FreezingTime], [FridgeTime], [ExpiryReminder], [LowStockReminder], [LowStockReminderUnit], [DailyConsumption], [DailyConsumptionUnit], [FridgeId], [ItemId]) VALUES (9211, N'ketchup', N'ketchup.png', N'nounit', N'Other', NULL, 180, 4, NULL, NULL, NULL, NULL, 2, 1098)
SET IDENTITY_INSERT [dbo].[FridgeItem] OFF
GO
SET IDENTITY_INSERT [dbo].[FridgeUser] ON 

INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (4, 1, 4, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (5, 1, 5, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (7, 1, 2, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (8, 1, 3, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (10, 3, 7, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (11, 3, 8, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (12, 3, 9, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (13, 4, 10, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (15, 4, 7, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (22, 1019, 1, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (1104, 1, 1048, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (2110, 2, 2, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (2113, 1030, 2053, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (4117, 2, 1, N'owner')
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (4118, 1, 1, NULL)
INSERT [dbo].[FridgeUser] ([Id], [FridgeId], [UserId], [Role]) VALUES (4119, 2, 3, NULL)
SET IDENTITY_INSERT [dbo].[FridgeUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Ingredient] ON 

INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (134, 3, NULL, 8, 5)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (1138, 3, NULL, 1, 2079)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (1139, 2, NULL, 4099, 2079)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (1140, 4, NULL, 8, 2079)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (5204, 2, NULL, 4099, 5)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6205, 8, NULL, 9148, 5)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6229, 12, NULL, 9148, 2079)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6232, 2, NULL, 9208, 4109)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6233, 2, NULL, 4103, 4109)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6234, 2, NULL, 6109, 4109)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6235, 2, NULL, 4103, 4110)
INSERT [dbo].[Ingredient] ([Id], [Quantity], [Unit], [FridgeItemId], [RecipeId]) VALUES (6236, 2, NULL, 4103, 4111)
SET IDENTITY_INSERT [dbo].[Ingredient] OFF
GO
SET IDENTITY_INSERT [dbo].[Item] ON 

INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1, N'Mutton', N'Mutton.png', N'Meat', 265, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (2, N'Chicken ', N'Chicken.png', N'Meat', 150, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (3, N'Bread', N'Bread.png', N'Bakery', 3, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (4, N'Egg', N'Eggs.png', N'Eggs', NULL, 30, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (5, N'Milk', N'Milk.png', N'Dairy', NULL, 4, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (7, N'Yogurt', N'Yogurt.png', N'Dairy', 10, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (8, N'Apple', N'Apple.png', N'Fruit', NULL, 15, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (9, N'Fish', N'Fish.png', N'Seafood', 100, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (10, N'Banana', N'Banana.jfif', N'Fruit', NULL, 6, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (11, N'Condense Milk', N'Condense Milk.png', N'Dairy', 250, 2, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (12, N'Beef', N'Beef.png', N'Meat', 365, 2, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (16, N'Tomato', N'Tomato.png', N'Vegetable', 365, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1014, N'Apricot', N'Apricot.png', N'Fruit', 90, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1015, N'Avocado', N'Avocado.png', N'Fruit', 7, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1017, N'Blackberries', N'Blackberries.png', N'Fruit', 12, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1018, N'Blueberries', N'Blueberries.png', N'Fruit', 12, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1019, N'Cherries', N'Cherries.png', N'Fruit', 180, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1020, N'Coconut', N'Coconut.png', N'Fruit', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1021, N'Cranberries', N'Cranberries.png', N'Fruit', 12, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1022, N'Dates', N'Dates.png', N'Fruit', 365, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1023, N'Grapes', N'Grapes.png', N'Fruit', 90, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1024, N'Grapefruit', N'Grapefruit.png', N'Fruit', 120, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1025, N'Guava', N'Guava.png', N'Fruit', 8, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1026, N'Kiwi', N'Kiwi.png', N'Fruit', 12, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1027, N'Lemon', N'Lemon.png', N'Fruit', 120, 21, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1028, N'Lime', N'Lime.png', N'Fruit', 120, 21, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1029, N'Mango', N'Mango.png', N'Fruit', 180, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1031, N'Orange', N'Orange.png', N'Fruit', 120, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1032, N'Papaya', N'Papaya.png', N'Fruit', 180, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1033, N'Peach', N'Peach.jpeg', N'Fruit', 180, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1034, N'Pear', N'Pear.png', N'Fruit', 240, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1035, N'Pineapple', N'Pineapple.jpeg', N'Fruit', 365, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1036, N'Pomegranate', N'Pomegranate.png', N'Fruit', 90, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1037, N'Raspberries', N'Raspberries.jpeg', N'Fruit', 12, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1038, N'Strawberries', N'Strawberries.jpeg', N'Fruit', 12, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1039, N'Watermelon', N'Watermelon.png', N'Fruit', NULL, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1041, N'Lychee', N'Lychee.jpeg', N'Fruit', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1044, N'Bell pepper', N'Bell peppers.png', N'Vegetable', 240, 10, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1045, N'Broccoli', N'Broccoil.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1046, N'Brussels sprouts', N'Brussels sprouts.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1047, N'Cabbage', N'Cabbage.png', N'Vegetable', 240, 21, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1048, N'Carrot', N'Carrots.png', N'Vegetable', 240, 21, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1049, N'Cauliflower', N'Cauliflower.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1050, N'Corn', N'Corn.png', N'Vegetable', 180, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1051, N'Cucumber', N'Cucumber.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1052, N'Green beans', N'Green beans.png', N'Vegetable', 240, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1053, N'Lettuce', N'Lettuce.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1054, N'Mushrooms', N'Mushrooms.png', N'Vegetable', 240, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1057, N'Spinach', N'Spinach.png', N'Vegetable', 240, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1060, N'Radish', N'Radish.png', N'Vegetable', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1062, N'Bitter gourd', N'Bitter gourd.png', N'Vegetable', 180, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1063, N'Pumpkin', N'Pumpkin.png', N'Vegetable', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1064, N'Eggplant', N'Eggplant.png', N'Vegetable', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1065, N'Capsicum', N'Capsicum.png', N'Vegetable', 180, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1066, N'Green chilli', N'Green chilli.png', N'Vegetable', 90, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1068, N'Lady''s finger', N'Lady''s finger.jpg', N'Vegetable', 90, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1071, N'Green peas', N'Green peas.png', N'Vegetable', 30, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1072, N'Spring onion', N'Spring onion.png', N'Vegetable', 30, 5, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1074, N'Butter', N'Butter.png', N'Dairy', 12, 90, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1075, N'Cheese', N'Cheese.png', N'Dairy', 7, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1077, N'Cream', N'Cream.png', N'Dairy', 2, 7, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1079, N'Margarine', N'Margarine.png', N'Dairy', 12, 90, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1081, N'Bagels', N'Bagels.png', N'Bakery', 6, 14, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1082, N'Croissant', N'Croissants.png', N'Bakery', 1, 2, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1095, N'Dough', N'dough.png', N'Other', NULL, 4, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1096, N'Honey', N'Honey.png', N'Other', NULL, 365, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1097, N'Jam', N'Jam.png', N'Other', NULL, 180, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1098, N'ketchup', N'ketchup.png', N'Other', NULL, 180, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1099, N'Mayonnaise', N'Mayonnaise.png', N'Other', NULL, 60, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1100, N'Pickel', N'Pickel.png', N'Other', NULL, 365, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1101, N'Chicken Korma', N'Chicken Korma.jpg', N'Cooked', NULL, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1102, N'Nihari', N'Nihari.jfif', N'Cooked', NULL, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1103, N'Keema', N'Keema.jpg', N'Cooked', NULL, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1104, N'Alo Palak', N'Alo Palak.jpg', N'Cooked', NULL, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1105, N'Bhindi', N'Bhindi.jfif', N'Cooked', NULL, 3, N'nounit')
INSERT [dbo].[Item] ([Id], [Name], [Image], [Category], [FreezingTime], [FridgeTime], [ItemUnit]) VALUES (1106, N'Shami kebab', N'Shami kebab.jpg', N'Cooked', NULL, 3, N'nounit')
SET IDENTITY_INSERT [dbo].[Item] OFF
GO
SET IDENTITY_INSERT [dbo].[Recipe] ON 

INSERT [dbo].[Recipe] ([Id], [Name], [Image], [Servings], [FridgeId]) VALUES (5, N'Egg Baryani', N'Egg Baryani.png', 4, 2)
INSERT [dbo].[Recipe] ([Id], [Name], [Image], [Servings], [FridgeId]) VALUES (2079, N'Mutton baryani', N'Mutton baryani_202349265319.jpg', 3, 2)
INSERT [dbo].[Recipe] ([Id], [Name], [Image], [Servings], [FridgeId]) VALUES (4109, N'Milkshake ', N'Milkshake _202361328617.jpg', 2, 2)
INSERT [dbo].[Recipe] ([Id], [Name], [Image], [Servings], [FridgeId]) VALUES (4110, N'banana', N'banana_2023613524120.png', 2, 2)
INSERT [dbo].[Recipe] ([Id], [Name], [Image], [Servings], [FridgeId]) VALUES (4111, N'my bana ice cream ', N'my bana ice cream _2023613545220.png', 2, 2)
SET IDENTITY_INSERT [dbo].[Recipe] OFF
GO
SET IDENTITY_INSERT [dbo].[RecipeNotification] ON 

INSERT [dbo].[RecipeNotification] ([Id], [Title], [Body], [Date], [MealDate], [MealTime], [Reply], [SenderId], [RecieverId], [FridgeId], [RecipeId]) VALUES (56, N'Request Recipe', N'Talha want to have Egg Baryani in Lunch 
 (2 servings)', CAST(N'2023-04-14T19:59:37.843' AS DateTime), CAST(N'2023-05-03T00:00:00.000' AS DateTime), N'Lunch', N'ok', 3, 1, 2, 5)
INSERT [dbo].[RecipeNotification] ([Id], [Title], [Body], [Date], [MealDate], [MealTime], [Reply], [SenderId], [RecieverId], [FridgeId], [RecipeId]) VALUES (1086, N'Request Recipe', N'Talha want to have Egg Baryani in Lunch 
 (2 servings)', CAST(N'2023-04-14T19:59:37.843' AS DateTime), CAST(N'2023-05-03T00:00:00.000' AS DateTime), N'Lunch', N'sorry', 3, 1, 2, 5)
INSERT [dbo].[RecipeNotification] ([Id], [Title], [Body], [Date], [MealDate], [MealTime], [Reply], [SenderId], [RecieverId], [FridgeId], [RecipeId]) VALUES (2084, N'Request Recipe', N'Obaid khan want to have Egg Baryani in Lunch 
 (2 servings)', CAST(N'2023-05-08T14:51:32.057' AS DateTime), CAST(N'2023-05-08T00:00:00.000' AS DateTime), N'Lunch', N'ok', 1, 2, 2, 5)
SET IDENTITY_INSERT [dbo].[RecipeNotification] OFF
GO
SET IDENTITY_INSERT [dbo].[ShoppingList] ON 

INSERT [dbo].[ShoppingList] ([Id], [Header], [Body], [Date], [FridgeId], [SenderId], [ReplierId], [FridgeItemId]) VALUES (6129, N'Item Order', N'Obaid khan need 2  Bread.', CAST(N'2023-05-23T14:48:45.487' AS DateTime), 2, 1, NULL, NULL)
INSERT [dbo].[ShoppingList] ([Id], [Header], [Body], [Date], [FridgeId], [SenderId], [ReplierId], [FridgeItemId]) VALUES (7129, N'Low Stock', N'Bread is running low in stock', CAST(N'2023-05-29T14:03:27.543' AS DateTime), 1, NULL, NULL, 1007)
INSERT [dbo].[ShoppingList] ([Id], [Header], [Body], [Date], [FridgeId], [SenderId], [ReplierId], [FridgeItemId]) VALUES (7133, N'Item Order', N'Obaid khan need 12  Banana.', CAST(N'2023-05-29T14:23:03.983' AS DateTime), 2, 1, 2, NULL)
INSERT [dbo].[ShoppingList] ([Id], [Header], [Body], [Date], [FridgeId], [SenderId], [ReplierId], [FridgeItemId]) VALUES (7134, N'Low Stock', N'Apple is running low in stock', CAST(N'2023-05-29T15:02:43.387' AS DateTime), 2, NULL, NULL, 6109)
SET IDENTITY_INSERT [dbo].[ShoppingList] OFF
GO
SET IDENTITY_INSERT [dbo].[Stock] ON 

INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (2130, N'Butter - 417', 1, NULL, CAST(N'2023-04-13' AS Date), CAST(N'2023-07-12' AS Date), 0, 3075)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (4153, N'Dough - 4994', 2, NULL, CAST(N'2023-05-08' AS Date), CAST(N'2023-05-12' AS Date), 0, 3070)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (4155, N'Keema - 5666', 2, NULL, CAST(N'2023-05-14' AS Date), CAST(N'2024-05-08' AS Date), 1, 4088)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (4156, N'Chicken Korma - 9828', 2, NULL, CAST(N'2023-05-14' AS Date), CAST(N'2024-05-08' AS Date), 1, 4090)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (4157, N'Shami kebab - 4577', 30, NULL, CAST(N'2023-05-14' AS Date), CAST(N'2024-05-08' AS Date), 1, 4091)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (5192, N'Mutton - 853', 1, NULL, CAST(N'2023-04-28' AS Date), CAST(N'2023-06-01' AS Date), 0, 1)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (7207, N'Avocado - 6747', 11, NULL, CAST(N'2023-05-29' AS Date), CAST(N'2023-06-03' AS Date), 0, 8142)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8215, N'Yogurt - 9732', 3, NULL, CAST(N'2023-06-04' AS Date), CAST(N'2023-06-11' AS Date), 0, 4099)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8216, N'Apple - 4210', 2, NULL, CAST(N'2023-06-06' AS Date), CAST(N'2023-06-15' AS Date), 0, 6109)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8221, N'Tomato - 5332', 3, NULL, CAST(N'2023-06-09' AS Date), CAST(N'2023-06-16' AS Date), 0, 8)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8230, N'Shami kebab - 4720', 14, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-09-09' AS Date), 1, 7139)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8232, N'Banana - 9077', 12, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-06-15' AS Date), 0, 4103)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8233, N'Egg - 7580', 12, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-06-15' AS Date), 0, 9148)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8235, N'Fish - 7922', 3, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-09-09' AS Date), 1, 9206)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8236, N'Milk - 2346', 2, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-06-15' AS Date), 0, 9208)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8237, N'Dough - 5644', 1, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-06-15' AS Date), 0, 9209)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8238, N'Jam - 6426', 2, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-12-08' AS Date), 0, 9210)
INSERT [dbo].[Stock] ([Id], [Label], [Quantity], [QuantityUnit], [PurchaseDate], [ExpiryDate], [IsFrozen], [FridgeItemId]) VALUES (8239, N'ketchup - 2862', 1, NULL, CAST(N'2023-06-11' AS Date), CAST(N'2023-12-16' AS Date), 0, 9211)
SET IDENTITY_INSERT [dbo].[Stock] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (1, N'Obaid khan', N'obaid', N'123')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (2, N'sheharyar', N'Sheharyar@gmail.com', N'123Sheharyar')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (3, N'Talha', N'Talha@gmail.com', N'123talha')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (4, N'Mudassir', N'Mudassir@gmail.com', N'123mudassir')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (5, N'Izhan', N'Izhan@gmail.com', N'123izhan')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (7, N'Sahid', N'Sahid@gmail.com', N'123sahid')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (8, N'Ahsan ', N'Ahsan@gmail.com', N'123ahsan')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (9, N'Hassan', N'Hassan@gmail.com', N'123hassan')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (10, N'Azeem', N'Azeem@gmail.com', N'123azeem')
INSERT [dbo].[User] ([Id], [Name], [Email], [Password]) VALUES (11, N'Azhar', N'Azhar@gmail.com', N'123azhar')
SET IDENTITY_INSERT [dbo].[User] OFF
GO
USE [master]
GO
ALTER DATABASE [Fridgefood] SET  READ_WRITE 
GO
