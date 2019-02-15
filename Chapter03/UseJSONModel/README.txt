UseJSONModel

使用JSONModel开源库

JSONModel是一个神奇的JSON与Model转换框架，它在Github上的开源库地址是 https://github.com/jsonmodel/jsonmodel 。
    JSONModel能帮助我们快速创建一个数据模型（Model），从而大大减少代码编写的工作量。这里，我们先来介绍下JSONModel的使用方法，把JSONModel添加到项目中，还是常规的导入方法，直接使用Cocoapods导入即可。
        pod 'JSONModel'
    JSONModel的基本使用方法如下。
• 基于JSONModel，创建一个类。
• 在.h文件中声明所需要的JSON Key值。
• 在.m文件中，不需要做什么。
    假如后台返回的JSON数据如下。
        d": "10", "country": "Germany", "dialCode": 49, "isInEurope": true}
    基于JSONModel创建一个Objective-C类，类名为CountryModel。在CountryModel.h文件中，将JSON中的Key声明为对应的属性。
        // CountryModel.h
        #import "JSONModel.h"

        @interface CountryModel : JSONModel
        @property (assign, nonatomic) int countryId;
        @property (strong, nonatomic) NSString *country;
        @property (strong, nonatomic) NSString *dialCode;
        @property (assign, nonatomic) BOOL isInEurope;
        @end
    而对应的CountryModel.m文件不需要做任何事情，在调用Model时，直接引用CountryModel.h，就可以把JSON转换为对应的Model对象，代码示意如下。
        #import "CountryModel.h"
        NSString *json = @"{\"id\":\"10\", \"country\":\"Germany\", \"dialCode\":49, \"isInEurope\":true}";
        NSError *err = nil;
        CountryModel *country = [[CountryModel alloc] initWithString:json error:&err];
    如果后台返回的JSON是规范的，那么，这里对应的所有属性都会与JSON的Key相对应。更为智能的是，JSONModel会尝试着把数据转换为你所期待的类型。
在实际项目中，App与后台接口定义的合理性至关重要。对于JSON与Model的转换来说，最理想的情况是，Model中的Key与JSON中的Key一一映射，这样就省去了类型的转换。尽管JSONModel提供了智能的转换方式，但任何数据转换都是有开销的。为了避免JSON的类型的不确定性带来的干扰，一种最为简单粗暴的方式是，后台返回的所有数据类型都统一定义为字符串类型，这种类型定义如下。
        {"id": "10", "country": "Germany", "dialCode": "49", "isInEurope": "1"}
    另外，后台在定义Key时的命名应尽可能避开使用id、description关键字，因为它们在Objective-C中有特殊的定义。当然，JSONModel也能够处理这些关键字，但没有必要刻意地做转换，因为数据类型的转换都是有开销的。
    接下来，看几个示例。
    （1）最简单的JSON数据结构；自动根据Key的名称来映射，JSON数据格式如下。
        {
            "id": 123,
            "name": "Product name",
            "price": 12.95
        }
    对应JSONModel类的属性如下，这里要注意Key的类型匹配。
        @interface ProductModel : JSONModel
        @property (nonatomic, assign) NSInteger id;
        @property (nonatomic, copy) NSString *name;
        @property (nonatomic, assign) float price;
        @end

    （2）JSON套有字典或数组：这就是所谓的模型嵌套，一个模型内包含有其他模型。
        {
            "orderId": 100,
            "totalPrice": 13.45,
            "product":
            {
                "id": 123,
                "name": "Product name",
                "price": 12.95
            }
        }
    从JSON数据可以看出，这个JSON本身是一个字典，而字典内部还嵌有一个字典，product所对应的字典。JSONModel能够很好地支持Model的嵌套，可以认为一个大的Model由多个子Model构成。在这种嵌套的情况下，要先创建子Model，再一层层往外扩展。具体到这个示例，需要先创建一个子Model——ProductModel，代码如下：
        @interface ProductModel : JSONModel
        @property (nonatomic, assign) NSInteger id;
        @property (nonatomic, copy) NSString *name;
        @property (nonatomic, assign) float price;
        @end
    接下来，再把ProductModel作为一个Model类型，内嵌到它的外一层。创建OrderModel的代码如下。
        @interface OrderModel : JSONModel
        @property (nonatomic, assign) NSInteger orderId;
        @property (nonatomic, assign) float totalPrice;
        @property (nonatomic, strong) ProductModel *product;
        @end

    （3）JSON中含有数组，例如：
        {
            "orderId": 104,
            "totalPrice": 103.45,
            "products": [
                 {"id": 123, "name": "Product #1", "price": 12.95},
                 {"id": 137, "name": "Product #2", "price": 82.95}
            ]
        }
    当JSON中嵌套数组时，该如何创建Model呢？这种情况下，数组还是那个数组，只不过数组内嵌的对象是一个Model，换句话说，这个数组是由Model填充的数组，对应的JSONModel如下。
        @interface ProductModel : JSONModel
        @property (nonatomic, assign) NSInteger id;
        @property (nonatomic, copy) NSString *name;
        @property (nonatomic, assign) float price;
        @end

        @interface OrderModel : JSONModel
        @property (nonatomic, assign) NSInteger orderId;
        @property (nonatomic, assign) float totalPrice;
        @property (nonatomic, strong) NSArray<ProductModel *> *products;
        @end
    这里要特别注意NSArray后面的尖括号所包含的协议<ProductModel>，这个协议是为JSONModel工作的，是必不可少的。

    接下来，我们介绍下JSONModel的几个属性用法，常用的属性有Optional和Ignore。
（1）JSONModel自带有一个有效性检查的功能，如果该后台返回的Key没有返回值，而且又是必需的，像下面这么写，就会抛出异常。从App运行的角度看，就会出现内退。
        @property (nonatomic, strong) NSString *someKey;
    一般情况下，我们不想因为服务器的某个值没有返回就使程序闪退，为避免这种情况，需要加一个关键字Optional。
        @property (nonatomic, strong) NSString <Optional> *someKey;
    注意，Optional关键字只能使用在类对象上。

（2）如果后台返回的JSON是合理的，那么我们在Model中所声明的属性都会自动与该JSON值相匹配，并且JSONModel也会尝试尽可能地转化成你所想要的数据。
        property (nonatomic, strong) NSString *city_id;
    后台所返回的JSON中的NSInteger类型，会转换成Model所需要的NSString类型。

（3）Ignore属性的用法：标识了Ignore的属性，在解析JSON数据时，可以完全忽略这个属性变量。一般情况下，忽略的属性主要用在该值不从服务器获取，而是通过手动编码的方式来人工设置。我们来看一段JSON数据。
    {
        "id": "123",
        "name": null
    }
        对应的Model是：
    @interface ProductModel : JSONModel
    @property (assign, nonatomic) int id;
    @property (strong, nonatomic) NSString <Ignore> *customProperty;
    @end
    我们注意到，customProperty这个属性在JSON中没有对应的Key，因为添加了<Ignore>，这个Model的customProperty将不会从JSON中去获取对应的数据，在进行JSON与Model转换时，customProperty将被忽略。在转换完成后，可以通过手动方式，根据业务需要为customProperty赋值。
        JSONModel有一个重要的方法：
    - (instancetype)initWithString:(NSString *)string error:(JSONModelError **)err;
        在读取JSON数据时，只需调用这个方法就可以返回Model对象，二者的Key可以自动对应起来，代码如下：
    NSMutableArray *retArray = [NSMutableArray array];
        WeatherCellModel *obj = [[WeatherCellModel alloc] initWithDictionary:dict error:nil];
        [retArray addObject:obj];   // 把Model对象都添加到数组中