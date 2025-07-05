public class J01_HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // 輸出字符串到控制台

        int age = 25; // 定義整數變量 age
        System.out.println("My age is: " + age); 

        double price = 19.99;
        System.out.println("The price is: $" + price); // 輸出浮點數到控制台

        float height = 1.75f; // 定義浮點數變量 height
        System.out.println("My height is: " + height + " meters"); //

        boolean isStudent = true; // 定義布林變量 isStudent
        System.out.println("Am I a student? " + isStudent); // 輸出布爾值到控制台

        String name = "Alice"; // 定義字符串變量 name
        System.out.println("My name is: " + name); // 輸出字符串

        float sum = (float)price + height; 
        System.out.println("The sum of price and height is: " + sum);

        char initial = 'A'; // 定義字符變量 initial
        System.out.println("My name starts with: " + initial); // 輸出字符到控制台

        float average = 6.7f; // 定義浮點數變量 average

        String name2 = "Alice";     // 聲明一個字符串變數 name

        int score = 85;
        if (score >= 90) {
            System.out.println("優秀");
        } else if (score >= 60) {
            System.out.println("及格");
        } else {
            System.out.println("不及格");
        }

        // 使用 switch 語句
        int day = 3; // 假設今天是星期三
        switch (day) {
            case 1:
                System.out.println("今天是星期一");
                break;
            case 2:
                System.out.println("今天是星期二");
                break;
            case 3:
                System.out.println("今天是星期三");
                break;
            case 4:
                System.out.println("今天是星期四");
                break;
            case 5:
                System.out.println("今天是星期五");
                break;
            case 6:
                System.out.println("今天是星期六");
                break;
            case 7:
                System.out.println("今天是星期日");
                break;
            default:
                System.out.println("無效的日期");
        }

    }
}