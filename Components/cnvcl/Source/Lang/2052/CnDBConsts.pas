{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2010 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnDBConsts;
{* |<PRE>
================================================================================
* 软件名称：CnPack 组件包
* 单元名称：数据库组件常量定义单元
* 单元作者：不得闲 (appleak46@yahoo.com.cn)
*           刘啸 (liuxiao@cnpack.org)
* 备    注：
* 开发平台：PWinXP + Delphi 5.0
* 兼容测试：PWin9X/2000/XP + Delphi 5/6/7
* 本 地 化：该单元中的字符串均符合本地化处理方式
* 单元标识：$Id: CnDBConsts.pas 418 2010-02-08 04:53:54Z zhoujingyu $
* 修改记录：2007.11.24 V1.0
*               创建单元，实现功能
================================================================================
|</PRE>}

interface

{$I CnPack.inc}

const
  // CnSQLAnalyzer
  SCnSQLAnalyzerName = '查询分析器组件';
  SCnSQLAnalyzerComment = '查询分析器组件';
  
  // CnADOUpdateSql
  SCnADOUpdateSqlName = 'ADO 多表更新组件';
  SCnADOUpdateSqlComment = 'ADO 多表更新组件';

resourcestring

  SCnIndexOut = '指定索引超过总文字字段数！';
  SCnSqlFilter = 'SQL 脚本(*.sql)|*.sql|文本文件(*.txt)|*.txt|所有文件(*.*)|*.*';
  SCnFoundSucced = '全部查找完成！';
  SCnReplaceSucced = '全部替换完成！';
  SCnMsg = '消息';
  SCnErrMsg = '错误';
  SCnOperateCancel = '操作被取消！';
  SCnResMsg = '结果';
  SCnUnUseConstr = '没有指定一个有效的数据连接或数据连接字符串！';
  SCnUsedTime = '耗时：';
  SCnVerWar = '对不起，本版本暂时不支持 %s 数据库引擎！';
  SCnExeSucced = '命令成功执行！';
  SCnAffectMsg = '（所影响的行数为 %d 行）';
  SCnCopyMenu = '复制';
  SCnFindMenu = '查找';
  SCnReplaceMenu = '替换';
  SCnOpenHint = '打开文件';
  SCnSaveHint = '保存文件';
  SCnFindHint = '查找替换文件';
  SCnUnDoHint = '撤消';
  SCnReDoHint = '重做';
  SCnCutHint = '剪切';
  SCnCopyHint = '复制';
  SCnPasteHint = '粘贴';
  SCnRunHint = '执行';
  SCnParse = '分析语法';
  SCnStop = '停止';
  SCnShowGrid = '显示消息网格';
     
implementation

end.
